From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Date: Mon, 30 Aug 2010 08:59:37 -0700
Message-ID: <4C7BD569.9000702@noir.com>
References: <4C7AB645.5090804@wpkg.org> <20100830001441.GA838@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hch@infradead.org,
	gg.mariotti@gmail.com,
	"Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
	tytso@mit.edu
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100830001441.GA838@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 8/29/10 17:14 , Josef Bacik wrote:
> On Sun, Aug 29, 2010 at 09:34:29PM +0200, Tomasz Chmielewski wrote:
>> Christoph Hellwig wrote:
>>> There are a lot of variables when using qemu.
>>>
>>> The most important one are:
>>>
>>>   - the cache mode on the device.  The default is cache=writethrough,
>>>     which is not quite optimal.  You generally do want to use cache=none
>>>     which uses O_DIRECT in qemu.
>>>   - if the backing image is sparse or not.
>>>   - if you use barrier - both in the host and the guest.
>> I noticed that when btrfs is mounted with default options, when writing
>> i.e. 10 GB on the KVM guest using qcow2 image, 20 GB are written on the
>> host (as measured with "iostat -m -p").
>>
>> With ext4 (or btrfs mounted with nodatacow), 10 GB write on a guest
>> produces 10 GB write on the host
> Whoa 20gb?  That doesn't sound right, COW should just mean we get quite a bit of
> fragmentation, not write everything twice.  What exactly is qemu doing?  Thanks,
Make sure you build your file system with "mkfs.btrfs -m single -d 
single /dev/whatever".  You may well be writing duplicate copies of 
everything.

--rich
