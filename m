From: Dennis Bergmann <d.bergmann@ftml.net>
Subject: Damaged super block / fs root
Date: Mon, 30 May 2011 17:59:54 +0200
Message-ID: <4DE3BEFA.7080106@ftml.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have accidently damaged the first block(s) of a btrfs partition
and can't mount it anymore.

I can see that my data is still intact by running a command like:

cat /dev/sda5 | hexdump -C | more

Do any (experimental) tools exist which would allow me to recover the files?


Thank you
