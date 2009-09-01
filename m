From: Atila <atila.alr@dpf.gov.br>
Subject: failed to read tree root
Date: Tue, 01 Sep 2009 15:08:15 -0300
Message-ID: <4A9D630F.5050106@dpf.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm having a 'failed to read tree root' message when trying to mount a 
disk which was mounting fine earlier.
Is there any hope to get the data back?

Atila


Sep  1 14:15:33 gentoo-atila [940695.233191] Btrfs loaded
Sep  1 14:15:33 gentoo-atila [940695.244360] device fsid 
5341dc082e28ff71-ba2fe914734b3884 devid 1 transid 16533 /dev/sdh1
Sep  1 14:15:33 gentoo-atila [940695.244901] btrfs: setting nodatasum
Sep  1 14:15:33 gentoo-atila [940695.253742] btrfs bad tree block start 
12241455839323779053 406978957312
Sep  1 14:15:33 gentoo-atila [940695.254241] btrfs bad tree block start 
12241455839323779053 406978957312
Sep  1 14:15:33 gentoo-atila [940695.254741] btrfs bad tree block start 
5557049029311685575 406978957312
Sep  1 14:15:33 gentoo-atila [940695.254744] btrfs: failed to read tree 
root on sdh1
Sep  1 14:15:33 gentoo-atila [940695.255140] btrfs: open_ctree failed

