From: Brian Martin <brianmartin@gmail.com>
Subject: varied drive size raid10
Date: Wed, 16 Jun 2010 03:19:04 -0400
Message-ID: <4C187AE8.4040705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When using raid10 btrfs on four disks of two different sizes (two of one 
size two of another) does btrfs know to match the similarly sized disks 
in a mirrored pair?

I guess a corallary would be: will btrfs stripe over the mirrored pairs 
until the smaller pair fills up and then continue writing to the larger 
pair?

Also, if raid10 is used with, say, 3 100gb drives and 1 250gb drive 
would the 250gb drive be able to fail without data loss?  Could it be 
fully utilized?  How about with a 500gb drive?

Thanks,
Brian
