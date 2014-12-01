Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7589 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752460AbaLADZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 22:25:56 -0500
Message-ID: <547BDF82.3030305@cn.fujitsu.com>
Date: Mon, 1 Dec 2014 11:24:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <pan$d4d18$d4463d$8df93dd7$d770703b@cox.net>
In-Reply-To: <pan$d4d18$d4463d$8df93dd7$d770703b@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Duncan <1i5t5.duncan@cox.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月01日 11:08
> Qu Wenruo posted on Mon, 01 Dec 2014 09:58:27 +0800 as excerpted:
>
>> [CRAZY IDEA]
>> So why not using SQL to implement the btrfsck inode-record things?
>> 2. Heavy dependency
>>      If use it, btrfs-progs will include RDBMS as the make and runtime
>>      dependency.  Such low level progs depend on high level programs
>>      like sqlite3 may be very strange.
> I expect this will turn many of the "traditionalists" off, at least.  I
> could see a lot of traditional sysadmins lumping btrfs in with systemd if
> it started requiring a db, much as one of the big objections to systemd
> is the dbus requirement... even for headless servers that have never
> required it before.  Of course they could be ignored, but do we really
> want to go there?
Oh,so terrible the systemd warfare. :(
This objection sounds very solid now.

Anyway, this is a crazy idea...
(Maybe it is only me so lazy to implement the rb-tree based things)
>
> (Personally, my gut reaction is "eew", and of course getting database
> file handling correct after an ungraceful shutdown/reboot is one of the
> big challenges for a filesystem as it is, so I'm not entirely sure
> storing information in a database file in ordered to use it to help fix
> the filesystem is a good idea since it could well be that you end up
> needing an fsck to restore the file... to do the fsck, but I could be
> convinced.  I'm worried about the ones that can't be.)
The db file is mostly used in memory, only when the metadata is really 
really big, maybe when the fs tree's level
is 7 or 8 we may need to use db file.
And the db file should be anonymous(unlinked but open) since it is only 
used in one btrfsck session,
not reused or really needed to be stored.
So I will not be a problem of restore or something like that.

>
>> 4. Copyright
>>      Will it cause any copyright problem if using non-GPL RDBMS like
>>      sqlite3 in GPLv2 btrfs-progs?
> I just checked and at least on gentoo, sqlite's license is registered as
> "public domain", which is legally mergeable with code under any other
> license free or proprietary, so there should be no problem with it.  If
> something else is used of course it would depend on its license.
>
> I believe the general kernel-rules practice for such compatible license
> merging is to keep code under compatible licenses in separate files and
> keep the individual files under their individual licenses.  While if it's
> compatible I don't believe that's generally an actual legal requirement,
> the BSD folks in particular tend to be /very/ sensitive about code
> formerly under the BSD license, for instance, merged directly into GPL
> headlined files, because in that case they can't reverse the process.
> Personally I don't see the big deal, since they seem to have /no/ problem
> with their code being taken proprietary where they can't even /look/ at
> it, but a /huge/ problem with it being taken GPL, where they may not be
> able to directly copy back to BSD, but they obviously have the code
> available to look at anyway and still mergeable provided they dual
> license, and that makes absolutely no sense to me. <shrug>
>
>
> So while I don't think it'll go over well, there should be no license
> issues at least with sqlite.
>
Thanks for the license check anyway.

Thanks,
Qu.
