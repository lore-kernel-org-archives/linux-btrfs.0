Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50390 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932112AbaA1UQn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 15:16:43 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: =?windows-1252?Q?Re=3A_Snapshots_=96_noob_questions?=
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52E808CB.9020005@gmail.com>
Date: Tue, 28 Jan 2014 13:16:38 -0700
Message-Id: <ABFB6A50-ACAF-4BAA-8A93-4BC4CB6D0D65@colorremedies.com>
References: <52E664E0.5070909@gmail.com> <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com> <52E808CB.9020005@gmail.com>
To: KC <impactoria@googlemail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 28, 2014, at 12:45 PM, KC <impactoria@googlemail.com> wrote:

> On 27/01/14 19:44, Chris Murphy wrote:
>> 
>> On Jan 27, 2014, at 6:53 AM, KC <impactoria@googlemail.com> wrote:
>>> 
>>> 3. If I make a snapshot of / and there are some separate partitions mounted under /mnt/ or /home/, will snapshot skip them?
>> 
>> A snapshot of a subvolume only snapshots that subvolume, not other subvolumes contained in it or other partitions/file systems.
>> 
> 
> Excellent, thank you.
> 
> If currently my /home is just a folder on the / subvolume, is there any way to promote existing /home to a subvolume status so that if I take a snapshot of /, the /home gets skipped?

Multiple ways. I think the easiest is for the subvolumes to be at the top level of the Btrfs volume, and mount them where you want with fstab. So for example on Fedora 20 my top level subvolumes are:

boot
root
home

root is mounted at / using mount option subvol=root
boot is mounted at /boot using mount option subvol=boot
home is mounted at /home using mount option subvol=home

I've also decided to put systemd-journals on a separate subvolume:
journald is mounted at /var/log/journal using mount option subvol=journald

That way I can snapshot root, and rollback but have a persistent journal rather than a snapshot specific journal. Of course /home is also persistent because I don't roll it back.

You could also rename /home, create a subvolume home within current subvolume root, then move the files from directory /home_old to the subvolume /home. Now when you snapshot rootfs, /home isn't snapshot. In this case you don't need to separately mount the home subvolume because it's available as if it were a directory. It's an organizational thing I don't know that there's a right or wrong here.

One thing that came up recently on the Fedora devel list though, with respect to roofs snapshots available in the mounted fs hierarchy, is that an old rootfs snapshot could contain vulnerabilities. So two ways to handle it are to keep snapshots in the top level of the fs outside of the mounted fs hierarchy (only mount it as needed when taking snapshots); and/or mount that snapshots subvolume with noexec or nosuid mount option. That way its executables aren't root executable.




Chris Murphy

