From: dima <dolenin@parallels.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 27 Feb 2012 22:54:10 +0900
Message-ID: <4F4B8B02.9080303@parallels.com>
References: <4F38B8F0.5020506@yahoo.com> <4F471E80.2040809@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F471E80.2040809@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Since several people asked to post the results, here they are.
I tried raw virtio disk with and without -z -C set and also qcow2 virtio 
disk without -z -C set and did not notice any difference in performance 
at all - Redhat 6.2 Minimal installs in 10 minutes in each case. The 
"abysmal" performance as it was some several months ago (like 10 minutes 
just for virtual disk formatting) under the same conditions is no more 
at least on 3.3.0-rc5.

best
~dima


On 02/24/2012 02:22 PM, dima wrote:
> On 02/13/2012 04:17 PM, Ralf-Peter Rohbeck wrote:
>> Hello,
>> is it possible to set nodatacow on a per-file basis? I couldn't find
>> anything.
>> If not, wouldn't that be a great feature to get around the performance
>> issues with VM and database storage? Of course cloning should still
>> cause COW.
>
> Hello,
> Going back to the original question from Ralf I wanted to share my
> experience.
>
> Yesterday I set up KVM+qemu and set -z -C with David's 'fileflags'
> utility for the VM image file.
> I was very pleased with results - Redhat 6 Minimal installation was
> installed in 10 minutes whereas it was taking 'forever' the last time I
> tried it some 4 months ago. Writes during installation were very
> moderate. Performance of VM is excellent. Installing some big packages
> with yum inside VM goes very quickly with the speed indistinguishable
> from that of bare metal installs.
>
> I am not quite sure should this improvement be attributed to the nocow
> and nocompress flags or to the overall improvement of btrfs (I am on
> 3.3-rc4 kernel) but KVM is definitely more than usable on btrfs now.
>
> I am yet to test the install speed and performance without those flags set.
>
> best
> ~dima
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
