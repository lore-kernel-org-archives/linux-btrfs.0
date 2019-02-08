Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91130C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48FB22147C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfBHHPw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:15:52 -0500
Received: from mout.gmx.net ([212.227.15.15]:58099 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfBHHPw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 02:15:52 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MBVwM-1h0Da41N3O-00AaKU for
 <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 08:15:50 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Reply-To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs as / filesystem in RAID1
Date:   Fri, 08 Feb 2019 08:15:49 +0100
Message-ID: <30996181.4P3RU5RJzb@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
References: <33679024.u47WPbL97D@t460-skr> <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net> <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:OBAfcYxHEV0HHo863OSvqQYiFWM/5EJWXZ9hSyZHP2GpXAzrKID
 AVjDlMsSKNM3SVe5jRYqOgL322If9G0e8pSptD3QC94nRiK5Qm1z2qZf7EYAa/BPjbTGh74
 dzVEYGm0b72qG/cj4lKSHr5+5hIB2RkbBUJ4Ht2qk+QCGSAUTgx77UWJLSTqLgbj0vEF4Xn
 ugevF6Jkh/0ZcVqblFUMQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:w1y/F1UBLEU=:0JcQoKA9qIlvnyxdLtP51V
 mRZCXi4DCID4M06zkuvpnfOTFoHMsHL1kt8quNV5RX6qACyFdCOHX6wJl5nsts4x5TXqSrUhg
 DrImuCKocivCY9+Tt53Tf44Pg1wriLLquxK229jrz9sjJ2dhuH+oEjeot3zRposW5oIEWYN5U
 jQtNfA9ro5phKZW3zGdHMyQyAKe9o9D1e/8sHIUA5HxsLCQx0lnx8231KswFHIEoaETrUeEXh
 ByOn2H/otKqdM6Np0OdVCJ57igpu6OUlitN7QkgRuHpihZ/TObPxjN2Bv/6X4nZUzzgdx1CfF
 ylCeln5LtPYFVQThLuA4J3vCAuCvJuU7uc1GicGIn9+qbyKiPj+RLFK/0wImdc8GSY9sd+IOD
 F1DL+rOjsEdgWd3NiCo5XZzIsa9tWoWd6YOr1Vy+PDNEZmo8KG/k/hrsuCgqUSciXVXdKi5HR
 G/NrFrF/VwewVG95spoKgPLoXvvQi+s52+qF8NgR9a0aXBXHSBYfMLHGW1Jxyb2YDiJTsPmU1
 C90dBmiFllKWDpFgDqXfm9uOuE7Dln1hoc0FrQopyQ/J5CAZBu6fO085oTuEwtoJettwCDvUp
 jhBkEWciSd990OIdw85wB1Wlaq8oeFykMqitcRLT0YVTaLNIAoN6RYveJWOQ8XULA3wetmC3U
 UjYDtwMSt5SmuYufon99rBnZYl33dMKXv71KuiVzZ128tOglRYmtOPNi/NbkoPOoS6ipz1XGp
 6SM5Ig+Cz1vnkGizF7q+FWpzWkzvOwW4EGCQ1eWuc8fHellI9AMPgy9lURat2bMmiG2eQqQ3X
 fP7ehBC5BD2nO2Bi74DX709rQ+D1IXiEQ3D47/pdDRxtBJuytoIOifRMOC9sI8B8VDItLJmlj
 fxFki3taM2d0LKx+uSQs8PWvhHif1uInSrMyONEqzwXRv9r8Qq8HzCinhLYifdrO9XSy2vqSt
 /npsnVj1slQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> * Normal desktop users _never_ look at the log files or boot info, and 
> rarely run monitoring programs, so they as a general rule won't notice 
> until it's already too late.  BTRFS isn't just a server filesystem, so 
> it needs to be safe for regular users too.
I guess a normal desktop user wouldn't create a RAID1 nor other RAID-things, right? So an admin take care of a RAID and monitor it (it doesn't matter if it a hardwareraid, mdraid, zfs raid or what ever)
and degraded works only with RAID-things, its not relevant for single-disk usage, right?

> Also, LVM and MD have the exact same issue, it's just not as significant 
> because they re-add and re-sync missing devices automatically when they 
> reappear, which makes such split-brain scenarios much less likely.
why does btrfs don't do that?


On Thursday, February 7, 2019 2:39:34 PM CET Austin S. Hemmelgarn wrote:
> On 2019-02-07 13:53, waxhead wrote:
> > 
> > 
> > Austin S. Hemmelgarn wrote:
> >> On 2019-02-07 06:04, Stefan K wrote:
> >>> Thanks, with degraded  as kernel parameter and also ind the fstab it 
> >>> works like expected
> >>>
> >>> That should be the normal behaviour, cause a server must be up and 
> >>> running, and I don't care about a device loss, thats why I use a 
> >>> RAID1. The device-loss problem can I fix later, but its important 
> >>> that a server is up and running, i got informed at boot time and also 
> >>> in the logs files that a device is missing, also I see that if you 
> >>> use a monitoring program.
> >> No, it shouldn't be the default, because:
> >>
> >> * Normal desktop users _never_ look at the log files or boot info, and 
> >> rarely run monitoring programs, so they as a general rule won't notice 
> >> until it's already too late.  BTRFS isn't just a server filesystem, so 
> >> it needs to be safe for regular users too.
> > 
> > I am willing to argue that whatever you refer to as normal users don't 
> > have a clue how to make a raid1 filesystem, nor do they care about what 
> > underlying filesystem their computer runs. I can't quite see how a 
> > limping system would be worse than a failing system in this case. 
> > Besides "normal" desktop users use Windows anyway, people that run on 
> > penguin powered stuff generally have at least some technical knowledge.
> Once you get into stuff like Arch or Gentoo, yeah, people tend to have 
> enough technical knowledge to handle this type of thing, but if you're 
> talking about the big distros like Ubuntu or Fedora, not so much.  Yes, 
> I might be a bit pessimistic here, but that pessimism is based on 
> personal experience over many years of providing technical support for 
> people.
> 
> Put differently, human nature is to ignore things that aren't 
> immediately relevant.  Kernel logs don't matter until you see something 
> wrong.  Boot messages don't matter unless you happen to see them while 
> the system is booting (and most people don't).  Monitoring is the only 
> way here, but most people won't invest the time in proper monitoring 
> until they have problems.  Even as a seasoned sysadmin, I never look at 
> kernel logs until I see any problem, I rarely see boot messages on most 
> of the systems I manage (because I'm rarely sitting at the console when 
> they boot up, and when I am I'm usually handling startup of a dozen or 
> so systems simultaneously after a network-wide outage), and I only 
> monitor things that I know for certain need to be monitored.
> > 
> >> * It's easily possible to end up mounting degraded by accident if one 
> >> of the constituent devices is slow to enumerate, and this can easily 
> >> result in a split-brain scenario where all devices have diverged and 
> >> the volume can only be repaired by recreating it from scratch.
> > 
> > Am I wrong or would not the remaining disk have the generation number 
> > bumped on every commit? would it not make sense to ignore (previously) 
> > stale disks and require a manual "re-add" of the failed disks. From a 
> > users perspective with some C coding knowledge this sounds to me (in 
> > principle) like something as quite simple.
> > E.g. if the superblock UUID match for all devices and one (or more) 
> > devices has a lower generation number than the other(s) then the disk(s) 
> > with the newest generation number should be considered good and the 
> > other disks with a lower generation number should be marked as failed.
> The problem is that if you're defaulting to this behavior, you can have 
> multiple disks diverge from the base.  Imagine, for example, a system 
> with two devices in a raid1 setup with degraded mounts enabled by 
> default, and either device randomly taking longer than normal to 
> enumerate.  It's very possible for one boot to have one device delay 
> during enumeration on one boot, then the other on the next boot, and if 
> not handled _exactly_ right by the user, this will result in both 
> devices having a higher generation number than they started with, but 
> neither one being 'wrong'.  It's like trying to merge branches in git 
> that both have different changes to a binary file, there's no sane way 
> to handle it without user input.
> 
> Realistically, we can only safely recover from divergence correctly if 
> we can prove that all devices are true prior states of the current 
> highest generation, which is not currently possible to do reliably 
> because of how BTRFS operates.
> 
> Also, LVM and MD have the exact same issue, it's just not as significant 
> because they re-add and re-sync missing devices automatically when they 
> reappear, which makes such split-brain scenarios much less likely.
> > 
> >> * We have _ZERO_ automatic recovery from this situation.  This makes 
> >> both of the above mentioned issues far more dangerous.
> > 
> > See above, would this not be as simple as auto-deleting disks from the 
> > pool that has a matching UUID and a mismatch for the superblock 
> > generation number? Not exactly a recovery, but the system should be able 
> > to limp along.
> > 
> >> * It just plain does not work with most systemd setups, because 
> >> systemd will hang waiting on all the devices to appear due to the fact 
> >> that they refuse to acknowledge that the only way to correctly know if 
> >> a BTRFS volume will mount is to just try and mount it.
> > 
> > As far as I have understood this BTRFS refuses to mount even in 
> > redundant setups without the degraded flag. Why?! This is just plain 
> > useless. If anything the degraded mount option should be replaced with 
> > something like failif=X where X would be anything from 'never' which 
> > should get a 2 disk system up with exclusively raid1 profiles even if 
> > only one device is working. 'always' in case any device is failed or 
> > even 'atrisk' when loss of one more device would keep any raid chunk 
> > profile guarantee. (this get admittedly complex in a multi disk raid1 
> > setup or when subvolumes perhaps can be mounted with different "raid" 
> > profiles....)
> The issue with systemd is that if you pass 'degraded' on most systemd 
> systems,  and devices are missing when the system tries to mount the 
> volume, systemd won't mount it because it doesn't see all the devices. 
> It doesn't even _try_ to mount it because it doesn't see all the 
> devices.  Changing to degraded by default won't fix this, because it's a 
> systemd problem.
> 
> The same issue also makes it a serious pain in the arse to recover 
> degraded BTRFS volumes on systemd systems, because if the volume is 
> supposed to mount normally on that system, systemd will unmount it if it 
> doesn't see all the devices, regardless of how it got mounted in the 
> first place.
> 
> IOW, there's a special case with systemd that makes even mounting BTRFS 
> volumes that have missing devices degraded not work.
> > 
> >> * Given that new kernels still don't properly generate half-raid1 
> >> chunks when a device is missing in a two-device raid1 setup, there's a 
> >> very real possibility that users will have trouble recovering 
> >> filesystems with old recovery media (IOW, any recovery environment 
> >> running a kernel before 4.14 will not mount the volume correctly).
> > Sometimes you have to break a few eggs to make an omelette right? If 
> > people want to recover their data they should have backups, and if they 
> > are really interested in recovering their data (and don't have backups) 
> > then they will probably find this on the web by searching anyway...
> Backups aren't the type of recovery I'm talking about.  I'm talking 
> about people booting to things like SystemRescueCD to fix system 
> configuration or do offline maintenance without having to nuke the 
> system and restore from backups.  Such recovery environments often don't 
> get updated for a _long_ time, and such usage is not atypical as a first 
> step in trying to fix a broken system in situations where downtime 
> really is a serious issue.
> > 
> >> * You shouldn't be mounting writable and degraded for any reason other 
> >> than fixing the volume (or converting it to a single profile until you 
> >> can fix it), even aside from the other issues.
> > 
> > Well in my opinion the degraded mount option is counter intuitive. 
> > Unless otherwise asked for the system should mount and work as long as 
> > it can guarantee the data can be read and written somehow (regardless if 
> > any redundancy guarantee is not met). If the user is willing to accept 
> > more or less risk they should configure it!
> Again, BTRFS mounting degraded is significantly riskier than LVM or MD 
> doing the same thing.  Most users don't properly research things (When's 
> the last time you did a complete cost/benefit analysis before deciding 
> to use a particular piece of software on a system?), and would not know 
> they were taking on significantly higher risk by using BTRFS without 
> configuring it to behave safely until it actually caused them problems, 
> at which point most people would then complain about the resulting data 
> loss instead of trying to figure out why it happened and prevent it in 
> the first place.  I don't know about you, but I for one would rather 
> BTRFS have a reputation for being over-aggressively safe by default than 
> risking users data by default.
> 

