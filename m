From: david@lang.hm
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 13:48:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1107141344250.919@asgard.lang.hm>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <20110714165516.GA15253@agk-dp.fab.redhat.com>
 <19999.18584.813855.541972@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Alasdair G Kergon <agk@redhat.com>, NeilBrown <neilb@suse.de>,
	Ric Wheeler <rwheeler@redhat.com>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: John Stoffel <john@stoffel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19999.18584.813855.541972@quad.stoffel.home>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Jul 2011, John Stoffel wrote:

> Alasdair> I'll just say that any solution ought to be stackable.
>
> I've been mulling this over too and wondering how you'd handle this,
> because upper layers really can't peak down into lower layers easily.
> As far as I understand things.
>
> So if you have btrfs -> luks -> raid1 -> raid6 -> nbd -> remote disks
>
> How does btrfs handle errors (or does it even see them!) from the
> raid6 level when a single nbd device goes away?  Or taking the
> original example, when btrfs notices a checksum isn't correct, how
> would it push down multiple levels to try and find the correct data?
>
> Alasdair> This means understanding both that the number of data access
> Alasdair> routes may vary as you move through the stack, and that this
> Alasdair> number may depend on the offset within the device.
>
> It almost seems to me that the retry needs to be done at each level on
> it's own, without pushing down or up the stack.  But this doesn't
> handle the wrong file checksum issue.
>
> Hmm... maybe instead of just one number, we need another to count the
> levels down you go (or just split 16bit integer in half, bottom half
> being count of tries, the upper half being levels down to try that
> read?)
>
> It seems to defeat the purpose of layers if you can go down and find
> out how many layers there are underneath you....

this is why just an arbatrary 'method number' rather than a bitmap or 
something like that should be used.

using your example:

> So if you have btrfs -> luks -> raid1 -> raid6 -> nbd -> remote disks

raid1 has at least 2 values, raid 6 has at least 2 values, the combination 
of the two stacked should have at least 4 values.

if each layer can query the layer below it to find out how many methods it 
supports, it can then combine each of the methods it supports with each of 
the methods supported by the layer below it.

this will stack to an arbatrary number of layers, only limited by how 
large the value is allowed to be limiting the combinational permutations 
of all the layers options.

David Lang
