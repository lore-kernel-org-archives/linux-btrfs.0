From: Arne Jansen <sensille@gmx.net>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 08:59:21 +0200
Message-ID: <4E1E93C9.4020109@gmx.net>
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: NeilBrown <neilb@suse.de>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E1E866E.2050405@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 14.07.2011 08:02, Ric Wheeler wrote:
> On 07/14/2011 06:56 AM, NeilBrown wrote:
>> I'm certainly open to suggestions and collaboration. Do you have in
>> mind any
>> particular way to make the interface richer??
>
> If a file system uses checksumming or other data corruption detection
> bits, it can detect that it got bad data on a write. If that data was
> protected by RAID, it would like to ask the block layer to try to read
> from another mirror (for raid1) or try to validate/rebuild from parity.
>
> Today, I think that a retry will basically just give us back a random
> chance of getting data from a different mirror or the same one that we
> got data from on the first go.

Another case that comes to mind is the 'remove device' operation.
To accomplish this, btrfs just rewrites all the data that reside
on that device to other drives.
Also, scrub and my recently posted readahead patches make heavy
use of the knowledge of how the raid is laid out. Readahead always
uses as many drives as possible in parallel, while trying to
avoid unnecessary seeks on each device.

-Arne

>
> Chris, Alasdair, was that a good summary of one concern?
>
> Thanks!
>
> Ric
>
