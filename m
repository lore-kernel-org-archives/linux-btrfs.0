From: Fabian Zeindl <fabian.zeindl@gmail.com>
Subject: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 10:21:57 +0100
Message-ID: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

 the subject is pretty selfexplanatory. I"m creating a btrfs using

sudo mkfs.btrfs -m raid1 -d raid1 <smalldisk> <largedisk>

it creates the fs, apparently with the size of the larger disk, no matter in which order i supply the disk-arguments.
How can this be correct?

Is there some way like "cat /proc/mdstat" to see what btrfs is doing and to assure myself my raid1 is secure? It's not
terribly important data, hence i'm trying btrfs, but i don't want to lose it either.

I posted this question on stackexchange as well: http://unix.stackexchange.com/questions/28357/why-does-btrfs-allow-to-create-a-raid1-with-mismatched-drives

Please CC me in any replies.

Regards
Fabian Zeindl