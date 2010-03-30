From: Mark Rada <marada@uwaterloo.ca>
Subject: Workaround for race condition at boot
Date: Mon, 29 Mar 2010 22:40:12 -0400
Message-ID: <9A0AC2A7-90F9-4B80-AF0F-8C65083DE1B5@mailservices.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In my time playing around with btrfs I have had difficulty in mounting =
and btrfs partitions that use multiple devices. I'm aware that there is=
 a note about a gotcha on the wiki, but I'm not trying to mount the btr=
fs partition as the root.

However, I have noticed that if I force a btrfs filesystem scan before =
trying to mount, then everything will work.

I originally created a bug report on the Gentoo Bugzilla:
http://bugs.gentoo.org/show_bug.cgi?id=3D309219


Thanks,

=97
Mark Rada
marada@uwaterloo.ca

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
