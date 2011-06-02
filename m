From: <kathleen.hodge@emc.com>
Subject: btrfs w/ckd
Date: Thu, 2 Jun 2011 15:45:07 -0400
Message-ID: <47C68B986D117D40A7E109AE2FC85C291128DB4A12@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: <kathleen.hodge@emc.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I'm trying to use mod3 ckds which are already RAID10 protection. (most =
of the doc I'm looking at uses fba instead of ckd, so I didn't know if =
this was a limitation)
I'm addressing the head device and able to use these devices with no pr=
oblem as ext3.  I've been reading that cache may remember that it used =
to be ext3, so I detached and reattached, but get the same result when =
trying to mount after formatting.

I use the following to make the file system after I've attached, varied=
 online, formated and partitioned (also tried without the journaling sw=
itch).
mke2fs -j -t btrfs /dev/dasdbj1

Then the mount command:
mount -t btrfs /dev/dasdbj1 /home/sdasd/d01
mount: /dev/dasdbj1: can't read superblock

Can you please give me some direction?Thanks,
          Kathy Hodge

           EMC=B2
Mainframe Software QA
Phone:  1-508-293-6121 x76121
Cell:      1-303 -887-9292
Email:    kathleen.hodge@emc.com



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
