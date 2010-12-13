From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 14:34:38 -0500
Message-ID: <4D06754E.5010100@gmail.com>
References: <1292174654.11248.10.camel@paddy-desktop> <4D05630E.7070809@bobich.net> <1292260671.11248.609.camel@paddy-desktop> <20101213182008.GB17928@mother>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: Tomasz Torcz <tomek@pipebreaker.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101213182008.GB17928@mother>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2010 01:20 PM, Tomasz Torcz wrote:
> On Mon, Dec 13, 2010 at 05:17:51PM +0000, Paddy Steed wrote:
>> So, no-one has any idea's on how to implement the cache. Would makin=
g it
>> all swap work, does to OS cache files in swap?
>    Quite the opposite.  Too many people have ideas for SSD-as-cache i=
n Linux,
> in non particular order:
> =E2=80=94 bcache
> =E2=80=94 cleancache
> =E2=80=94 btrfs temperature tracking
> =E2=80=94 dm-hstore
> =E2=80=94 dm-cache / flashcache
>
>    Patches are in various states of implementation, some with explici=
t btrfs
> support.  There's no clear winner at this time, but some of above sol=
utions
> are shipped in distro kernels.
>

People are working on quite a few ways that btrfs can leverage SSD devi=
ces. One=20
technique would be to use the SSD as a block level cache, another would=
 be to=20
steer all metadata to the SSD (leaving your bulk data on normal drives)=
=2E

ric


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
