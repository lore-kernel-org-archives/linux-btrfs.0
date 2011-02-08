From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Tue, 8 Feb 2011 06:57:50 +0000 (UTC)
Message-ID: <iiqphe$217$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm hitting this issue - sda5 is a normal device, nothing to do with 
loop, encryption etc.

# mkfs.btrfs /dev/sda5

WARNING! - Btrfs v0.19-35-g1b444cd-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

error checking /dev/sda5 mount status

Is there something I can do to resolve this?

Thank you

Lubos

