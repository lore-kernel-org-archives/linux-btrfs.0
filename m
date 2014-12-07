Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:37429 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaLGI4s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Dec 2014 03:56:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 07 Dec 2014 09:56:44 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs device delete missing - Input/output error
In-Reply-To: <CAJCQCtTmc4ZeT=Av=VFeaYXXxfbUhdoUuoEp=xkqZ=xqxLm4kA@mail.gmail.com>
References: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
 <CAJCQCtRh7HU9yd-pxgXzXebVcjukQh6Lyhzfcd6bBJppyCxChQ@mail.gmail.com>
 <88e897a70d1ac64a5b6b2c4b2e9e49d5@admin.virtall.com>
 <CAJCQCtSGy5MBVC4hQUgHBtSy+6kNOap_0Mfb7f9G4HJH9AmtUQ@mail.gmail.com>
 <1225b43cd030194ef1ee3db419aa7a5e@admin.virtall.com>
 <CAJCQCtTmc4ZeT=Av=VFeaYXXxfbUhdoUuoEp=xkqZ=xqxLm4kA@mail.gmail.com>
Message-ID: <984967a4c28eec404f8766b353021cd6@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-07 06:26, Chris Murphy wrote:
> On Sat, Dec 6, 2014 at 2:17 AM, Tomasz Chmielewski <tch@virtall.com> 
> wrote:
> 
>> After we run again btrfs device delete missing /home, the newly 
>> created
>> directory eventually (/home/backup/ma-int/weekly.tmp) is being 
>> detected as
>> "csum failed ino ...".

> If that comes up clean then chances are this is file corruption and
> you can mount and do:
> 
> btrfs scrub start -r <MP>

Actually, this seemed to be enough.

I didn't realize that scrub would print the names of corrupted files.

After removing them, "btrfs device delete missing" is finally making 
some progress (previously, it would break at 300+GB; still running now):

# btrfs fi show /home
Label: none  uuid: 92e93437-cc9f-475d-a739-085f3270896b
         Total devices 3 FS bytes used 1.40TiB
         devid    2 size 1.70TiB used 1.42TiB path /dev/sdb4
         devid    3 size 1.70TiB used 807.00GiB path /dev/sda4
         *** Some devices missing

Btrfs v3.14.2


Thanks for your hints!

-- 
Tomasz Chmielewski
http://www.sslrack.com

