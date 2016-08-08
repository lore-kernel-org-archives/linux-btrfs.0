Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53885 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcHHTDC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 15:03:02 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bWppD-0002Nm-1G
	for linux-btrfs@vger.kernel.org; Mon, 08 Aug 2016 21:02:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Strange behavior after "rm -rf //"
Date: Mon, 8 Aug 2016 19:02:52 +0000 (UTC)
Message-ID: <pan$b523d$8764d220$8ac2587d$2fa78210@cox.net>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ivan Sizov posted on Mon, 08 Aug 2016 19:30:16 +0300 as excerpted:

> I'd ran "rm -rf //" by mistake two days ago. I'd stopped it after five
> seconds, but some files had been deleted. I'd tried to shutdown the
> system, but couldn't (a lot of files in /bin had been deleted and
> systemd didn't work). After hard reboot (by reset button) and booting to
> a live USB a strange thing was discovered.
> 
> Deleted files are present when I "mount -r" the disk, but btrfs-restore
> tells they are deleted ("We have looped trying to restore files too many
> times to be making progress").
> 
> What does it mean? Will those files be deleted after RW mount?

Chris is likely correct in your case, but I'd like to point out three 
things.

1)  The looping ... warning in btrfs restore is obviously there for a 
reason, because under some circumstances the filesystem will be damaged 
in such a way that restore /can/ loop without making progress, but that's 
not always the case, and in fact, in my own experience, has /never/ been 
the case.

Far more common, at least from my own experience, is seeing that warning 
simply due to directories containing a large number of files, even when 
restore /is/ working properly and restoring the files.  I don't know 
where the cutover is, but there's a reason it's a warning that allows you 
to say continue, and in every single case from my own experience, 
continuing /enough/ times eventually resulted in a successful restore 
with no missing files that I could tell (tho I didn't do a before/after 
comparison, just never missed anything but symlinks, etc, before the 
option to restore them too was added).

So if you haven't tried it yet, tell restore to continue despite the 
warning and see if it eventually does make progress.

Some people even automate the process using yes | btrfs restore ... or 
similar, tho I've never needed that here, possibly because I use multiple 
relatively small partitions (all under 50 GiB each except for my media 
partition and its backup).  I guess if they do decide btrfs restore is in 
an infinite loop, say after hours with no increase in the total size of 
the files restored, they'd have to break out of the loop manually, tho 
I've seen several posts where people were asking for restore to have a 
built-in continue option, or where they used automation, and none where 
they had to break the loop manually, so I'd guess it's actually pretty 
rare that a real infinite loop actually happens.

And because btrfs is copy-on-write and the old roots stay around for 
awhile, provided you take pains not to mount the filesystem writable or 
if you do not to write too much to it, since the more you write the less 
likely you are to be able to fully recover older transactions, you can 
likely use restore manually with the -t <transid> option and btrfs-find-
root to find an appropriate transid, to get the files back even if they 
do otherwise appear to be deleted.

See the wiki for instructions on that.  If you have a new enough btrfs-
progs, the page should be referenced in the btrfs-restore manpage.  But 
here it is anyway, since I have the manpage open ATM:

https://btrfs.wiki.kernel.org/index.php/Restore

2) Primarily because you didn't mention it and it can be handy in other 
circumstance, if you're unaware of it, read up on magic sysrequest, aka 
sysrq aka srq.

$KERNDIR/Documentation/sysrq.txt ... and various googlable articles on 
the subject.

Basically, any time you'd otherwise resort to a hard reboot, try a magic-
srq sequence first.  Longer version: reisub.  Shorter version, just the 
sub.  That's emergency Sync, remoUnt-read-only, reBoot (thus s-u-b).

It won't always work, particularly for kernel crashes, but even if it 
doesn't you can get a feel for how bad the crash was by the response or 
lack thereof (if the s and u light up the storage device activity LED, 
the kernel was alive and considered it safe to still write to storage, if 
they don't show activity but the b still reboots, the kernel was alive 
but either nothing dirty to write or the kernel considered itself damaged 
and thus wasn't going to risk writing to storage, if none work, the 
kernel itself was dead).

Because your problem this time was userspace, simply no binaries to run, 
that should have worked, safely shutting down the filesystem.

Altho arguably in this case a hard reboot was the better choice, since 
that final commit might have been lower risk for the filesystem, but 
would have likely finalized those deletions that you can now recover.  
(Tho with btrfs being copy-on-write, there's a fair chance you'd have 
been able to restore the files anyway, if done right away, using restore 
and manually pointing it at an earlier root.)

So you arguably did the right thing with a hard reboot here anyway, but 
in other cases, magic-srq is incredibly useful to know and may just save 
your butt, as I believe it has mine a few times by now.

3) I did something similar a couple years ago.  In my case, I was 
(unwisely) testing a script as root, with a typo in a variable name so it 
was an empty variable and thus started from / instead of the intended 
path.

Fortunately, I have backups, tho I don't keep them as current as I might, 
and it took out /bin and /boot and then warned me about /dev, which it 
couldn't delete due to that being the devfs mountpoint.  It proceeded 
into /etc, but that's where I stopped it after the warning about /dev, so 
I still had /usr/bin and the libs as well as /home, and could rebuild 
/bin and /etc from backups.

But the point it drove home to me is one I had heard before and 
fortunately was living by, that an admin has as much to fear from fat-
fingering something as he does from device, filesystem or software update 
failure.  And of course I shouldn't have been testing that script as 
root, and anything that scripts rm -r /$variable/* deletions like that 
needs at minimum an empty-var test that only proceeds with the rm if the 
variable isn't empty/null.

But the primary point is that if it's not backed up, by the inaction of 
failing to do that backup, you are in a very real and non-negotiable 
after-the-fact way, defining that data as worth less than the time and 
resources required to do the backup.

Fortunately I did have a (tested, if it's not tested it's not yet a 
backup!) backup, tho I don't always keep my backups current.  But at 
least I know the risk is limited to the updates between that backup and 
the current time, and I recognize that by not doing more regular backups, 
I am in a very real way defining that data in the gap as of only trivial 
value, to the point that I recognize the risk and when I start getting 
uncomfortable with the size of the data in that difference gap, I know 
it's time to do another backup.


And by that definition, it's impossible to lose data more valuable than 
the cost of an additional level of backup that would have kept it safe, 
whether that's no backup for data of trivial value, only a single on-site 
backup for data worth a bit more, or a hundred (or a thousand) levels of 
backup at 50 sites in 20 countries on 5 continents, because the data 
really is /that/ valuable.

So if you /think/ you value the data, have the backups demonstrating that 
value, because if you don't, you have a very real possibility of 
demonstrating that you did /not/ value the data as much as you claimed 
to, because it wasn't backed up and that lack of backup demonstrated the 
lie in any claim to the contrary.  IOW, backups speak louder than words!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

