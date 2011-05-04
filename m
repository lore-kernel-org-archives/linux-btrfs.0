From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 10:39:52 -0400
Message-ID: <4DC16538.3070900@redhat.com>
References: <4DC07A10.7070200@mur.at> <20110504002815.GA27861@dhcp231-156.rdu.redhat.com> <4DC0A153.3080806@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC0A153.3080806@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2011 08:44 PM, Martin Schitter wrote:
> Am 2011-05-04 02:28, schrieb Josef Bacik:
>> Wait why are you running with btrfs in production?
>
> do you know a better alternative for continuous snapshots? :)
>
> it works surprisingly well since more than a year.
> well the performance could be better for vm-image-hosting but it works.
>
> we used cache='writeback' for a long time but now all virtual instances
> have set cache='none'
>
>> What OS is in this vm image?
>
> 2.6.30-bpo.1-amd64 with virtio-driver
>
> could you give me some advice how to debug/report this specific problem
> more precise?
>

So there is a problem with DIO, since userspace can modify pages in 
flight we will end up with the wrong checksums since the data can change 
in flight.  I was trying to come up with a way to fix this but there's 
really nothing to be done at the moment other than turn off checksumming 
per file.  Windows was particularly bad about this, but I hadn't seen it 
with Linux guests (even though it should still be happening).  So I'll 
come up with something to turn off checksumming per file to get around 
this for now, I'll try and get to that soonish.  Thanks,

Josef
