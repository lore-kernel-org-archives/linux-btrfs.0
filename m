From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC][BTRFS-PROG] Avoid to scan cdrom and floppy
Date: Thu, 16 Jun 2011 10:14:47 -0400
Message-ID: <4DFA0FD7.8010908@redhat.com>
References: <Bnwmy4zD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bnwmy4zD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2011 04:35 PM, Helmut Hullen wrote:
> Hallo, Goffredo,
> 
> Du meintest am 15.06.11:
> 
>> thanks to the last Hugo's email, I restart to work on the patch which
>> avoid to scan cdrom and floppy during a "btrfs filesystem show" and a
>> "btrfs device scan". Comparing to my previous patch I modified the
>> strategy, and now the scan of the devices is based on the content of
>> the file /proc/partitions. The old behavior may be set  passing the
>> "--all-devices" options.
> 
> Thank you - it's nice for all who don't use udev.
> 

Who the hell doesn't use udev?

Josef
