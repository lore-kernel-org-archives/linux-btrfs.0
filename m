Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbbCEQEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Mar 2015 11:04:00 -0500
Message-ID: <54F87E6A.9090401@redhat.com>
Date: Thu, 05 Mar 2015 10:03:54 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com, Eryu Guan <guaneryu@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs oops while mounting fuzzed btrfs image
References: <20150305070933.GB17015@dhcp-13-216.nay.redhat.com> <20150305094611.GA4147@localhost.localdomain>
In-Reply-To: <20150305094611.GA4147@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/5/15 3:46 AM, Liu Bo wrote:
> On Thu, Mar 05, 2015 at 03:09:33PM +0800, Eryu Guan wrote:
>> Hi,
>>
>> I was testing btrfs with fsfuzzer and encountered a divide error on
>> mount, kernel version 3.19 and 4.0-rc1.
>>
>> I found a similar bug on kernel bugzilla
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=88611
>>
>> Please find the fuzzed btrfs image in the buzilla, and the following
>> command will reproduce:
>>
>> mount -o loop btrfs.img /mnt/btrfs
> 
> A divide by 0 oops.
> 
> My printk shows that a raid56 chunk has a negative map->length, so we need to find out
> how fsfuzzer made that.  Can you share your script so that we can
> reproduce the oops?

All you need to reproduce the oops is the image Eryu provided.

fsfuzzer intentionally damages the filesystem, simulating what might happen
if hardware goes bad, disks fail, admins dd to the wrong disk, memory corrupts,
bugs happen, etc.

The point is that filesystems need to be robust in the face of unexpected data
on the disk, and Eryu has uncovered a case where btrfs is not.  :)

-Eric
