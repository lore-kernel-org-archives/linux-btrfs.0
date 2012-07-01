Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51681 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2GAPAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 11:00:08 -0400
Received: by vcbf11 with SMTP id f11so3111294vcb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2012 08:00:07 -0700 (PDT)
MIME-Version: 1.0
From: Markus Rothe <markus@unixforces.net>
Date: Sun, 1 Jul 2012 16:59:36 +0200
Message-ID: <CALi3HZrwGO9=X3RG5FfN_04jW0F7T=405pVy4BXZg_6hE4W6XQ@mail.gmail.com>
Subject: Strange directories in /
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am running btrfs for a few months now. I just realized that I have a
few strange directories in /

% ls / -1
?
???J??
 QӇ??
PL????
PR????
bin
boot
dev
etc
home
lib
lib32
lib64
lost+found
media
mnt
opt
proc
p?c'??
root
run
sbin
sys
tmp
usr
var
??????

Is this a known problem? I have absolutely no idea where these
directories come from.

Best regards,

Markus
