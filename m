From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Date: Tue, 31 Aug 2010 14:46:49 -0700
Message-ID: <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
References: <4C7AB645.5090804@wpkg.org>
	<20100830001441.GA838@dhcp231-156.rdu.redhat.com>
	<4C7BD569.9000702@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hch@infradead.org, gg.mariotti@gmail.com,
	"Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
	tytso@mit.edu
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C7BD569.9000702@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 30, 2010 at 8:59 AM, K. Richard Pixley <rich@noir.com> wrot=
e:
> =C2=A0On 8/29/10 17:14 , Josef Bacik wrote:
>>
>> On Sun, Aug 29, 2010 at 09:34:29PM +0200, Tomasz Chmielewski wrote:
>>>
>>> Christoph Hellwig wrote:
>>>>
>>>> There are a lot of variables when using qemu.
>>>>
>>>> The most important one are:
>>>>
>>>> =C2=A0- the cache mode on the device. =C2=A0The default is cache=3D=
writethrough,
>>>> =C2=A0 =C2=A0which is not quite optimal. =C2=A0You generally do wa=
nt to use cache=3Dnone
>>>> =C2=A0 =C2=A0which uses O_DIRECT in qemu.
>>>> =C2=A0- if the backing image is sparse or not.
>>>> =C2=A0- if you use barrier - both in the host and the guest.
>>>
>>> I noticed that when btrfs is mounted with default options, when wri=
ting
>>> i.e. 10 GB on the KVM guest using qcow2 image, 20 GB are written on=
 the
>>> host (as measured with "iostat -m -p").
>>>
>>> With ext4 (or btrfs mounted with nodatacow), 10 GB write on a guest
>>> produces 10 GB write on the host
>>
>> Whoa 20gb? =C2=A0That doesn't sound right, COW should just mean we g=
et quite a
>> bit of
>> fragmentation, not write everything twice. =C2=A0What exactly is qem=
u doing?
>> =C2=A0Thanks,
>
> Make sure you build your file system with "mkfs.btrfs -m single -d si=
ngle
> /dev/whatever". =C2=A0You may well be writing duplicate copies of eve=
rything.
>
There is little reason not to use duplicate metadata.  Only small
files (less than 2kb) get stored in the tree, so there should be no
worries about images being duplicated without data duplication set at
mkfs time.
