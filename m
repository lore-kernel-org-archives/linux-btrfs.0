Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3ABC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AC2920825
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AC2920825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbeKQCaV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:30:21 -0500
Received: from mout.gmx.net ([212.227.15.18]:51533 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbeKQCaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 21:30:21 -0500
Received: from chaos-desktop.localnet ([88.67.151.196]) by mail.gmx.com
 (mrgmx002 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0MCLcP-1gF86I3uHx-0095qN for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018
 17:17:20 +0100
From:   Stephan Olbrich <stephanolbrich@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: bad tree block start, want 705757184 have 82362368
Date:   Fri, 16 Nov 2018 17:17:19 +0100
Message-ID: <1758973.r4I5FPff6i@chaos-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:4iMIhbsoLdqUgNhUDlB7lBrBblgqlAO0lBcM11rIciMeVwzEaNo
 oHkI18vSaOAJMU8tZ5nLGm+eNCwYs+aS67CBR7oJSB+qPk9WPtmTu5WKOKTN7bmX4QfN8n8
 HnedpORegU/utuAUs5w//XL3kX7HN0f8OHECpHS0aUQ7BTA6P3I5VAzm8KClgWFduWESGuC
 yoXn4AoGLo5/MBU06XLbQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:E1LiLiqzkHo=:eskyKU3CMU1TjsRJe1gbN6
 OWPa60jZk9XSdWCW+wxgvjtggh2JelbZ6J/jgjLSGNSZtHYx/fBakTu0K9+I+0sh8ZBAMeM1b
 cnkxlZBvUNWSTgj/UXZZnGKzD+xsHHt0jKvQRmVw1vxwrmOBkvCz/h7ogyfrxEpuQrkLQ2lUo
 Q19FBFL7UaboYOLGxEV4o397Z56nuecNDAQ1xy0urS0HdCXTI8hTcL8zODK2fSPqeTVRj7HMW
 lMTFRfrvjLN+Sx+aiEurGgiWqm2mZkaM7kW29C/DA8FDxQtWc4MRx4WeYkPIDd7mrD7IGJzAt
 kWrIDSLklcg+vkorThXWRHJgm5V8ACUjYBtRUpxId0G8t4+Nc86pska5ebXHiK7Mg161HnhvC
 TjjtMM8yDqfBcknEp7j5vU01KEhbEK679+whb53+i87yIJrFNqh8ccCnS4uZOmMYiNKgkVTNh
 x1tLHsEWgXAr/iieLYFNoqSqG2Q3VxV1bIrXyvFr6iz4JfEFMvZrUPtp6aC8I6eAtXpMGIXag
 nF9SA4DLS/Li+gyeGBu15Dv81Kc0d6NHWiz7I7egXcbic6NbeKQ1PX3wTSJdObmrwdS7CqANE
 x3OtpO+IbKpZMGVeN0KqRTFzUDOq/euvG4TxTj5XFnydXwiNZpL+HmL6QU//13s7uu+Tg3zs/
 a8U0ZIG/rwzne4PUw7sAcfx2kE1GJbklUXorOep5RHzzlaiFTKDfT4OtNP4Cl5TPO+bpbxUrJ
 FtL7w9AaKjSZJn2EVfR5FLllc7meIbR0GpS3GcivUvOj7sYqXYJHcxUjxv3QVep91oQyJfJXe
 RceOD7MHH3AtldmzjvrnOg28vUt9bqc8T1E+gvxMz7Iu96dfWNFvQCK0HWcdvPWQjCultdt3i
 jFMoXy+0Nlaygp3yl9DKHlaz3AMAdj4E21gSlbd0nugTPkS8nb7UdPzz36H8YWnUJXpCH726P
 IxquoqxKlvA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

a few days ago my root file system (simple btrfs on a SSD, no RAID or anything) suddenly became read only. 
Looking at dmsg, I found this:

[   19.285020] BTRFS error (device sda2): bad tree block start, want 705757184 have 82362368
[   19.285042] BTRFS: error (device sda2) in __btrfs_free_extent:6804: errno=-5 IO failure
[   19.285048] BTRFS info (device sda2): forced readonly
[   19.285051] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2934: errno=-5 IO failure
[   19.287213] BTRFS error (device sda2): pending csums is 41889792

Late on I got the same errors for my /home partition (on the same drive) as well.
I have snapshots of all partitions on another drive made by btrbk. To get a working system, I made new (rw) snapshots
of the most recent backup and setup grub and fstab, so my system would boot from the other drive.
Unfortunately now I got the "bad tree block start" error again at least once in dmesg but I didn't save it and it's not in syslog :-(
What I remember is, that it was followed by other btrfs error messages saying something about correcting something.
And the filesystem was still read/write this time.
At the moment I can't reproduce it.

Is there any way to find out, which files are affected by the errors above? I don't really trust the data on the drive I'm using at the
moment, as it has shown errors as well, but I have a less current backup on yet another drive but at it is a few weeks old, I don't
want to use it to setup the system on the SSD again, but just copy the relevant files if possible.
Or is it possible to repair the original file system?

Some information about my system:
Kubuntu 18.04
Kernel 4.19.1 when the problem occured, now 4.19.2
btrfs-tools 4.15.1

Regards,
Stephan





