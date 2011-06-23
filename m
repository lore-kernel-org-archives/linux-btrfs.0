From: Josef Bacik <josef@redhat.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Thu, 23 Jun 2011 17:35:19 -0400
Message-ID: <4E03B197.3060009@redhat.com>
References: <4E026FD4.7020606@podzimek.org> <1308793398-sup-9234@shiny> <20110623195409.GA21007@dhcp231-156.rdu.redhat.com> <loom.20110623T230224-841@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Daniel Witzel <dannyboy48888@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110623T230224-841@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/2011 05:11 PM, Daniel Witzel wrote:
> Well still no cigar, didnt even change the error output. Thank you though for
> at least trying to help. here goes the error info with your patch applied to
> /fs/btrfs/disk-io.c:
>
> mount -o ro /dev/sdf1 (same for c1,d1,etc) /btrfs (dmesg output)
> [ 1647.330104] btrfs: open_ctree failed
> [ 1683.328038] device label 1TB0 devid 1 transid 2135 /dev/sdf1
> [ 1683.344059] parent transid verify failed on 2206281838592 wanted 2135 found
> 1545
> [ 1683.349109] btrfs: open_ctree failed

You didn't apply it right then, because you shouldn't see these errors 
anymore.  Thanks,

Josef
