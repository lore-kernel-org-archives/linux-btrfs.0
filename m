From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: (renamed thread) btrfs metrics
Date: Wed, 04 Jan 2012 12:48:05 +0100
Message-ID: <4F043C75.1080204@pocock.com.au>
References: <4F01BF5D.2070801@pocock.com.au> <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com> <4F01C6DC.3040609@pocock.com.au> <20120102151422.GA27122@carfax.org.uk> <4F01DA85.4050107@pocock.com.au> <20120102163944.GB27122@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120102163944.GB27122@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


>> I am looking at what metrics are needed to monitor btrfs in production.
>>  I actually look after the ganglia-modules-linux package, which includes
>> some FS space metrics, but I figured that btrfs throws all that out the
>> window.
>>
>> Can you suggest metrics that would be meaningful, do I look in /proc or
>> with syscalls, is there any code I should look at for an example of how
>> to extract them with C?  Ideally, Ganglia runs without root privileges
>> too, so please let me know if btrfs will allow me to access them
> 
>    It depends on what you want to know, really. If you want "how close
> am I to a full filesystem?", then the output of df will give you a
> measure, even if it could be up to a factor of 2 out -- you can use it
> for predictive planning, though, as it'll be near zero when the FS
> runs out of space.


Maybe if you look at it from the point of the sysadmin and think about
what questions he might want to ask:

a) how much space would I reclaim if I deleted snapshot X?

b) how much space would I reclaim if I deleted all snapshots?

c) how much space would I need if I start making 4 snapshots a day and
keeping them for 48 hours?

(Ganglia also sums data across the enterprise, so if such metrics are
implemented, the admin can quickly see the sum of all snapshot usage on
his grid/cluster)

and also:

d) what metrics would be useful for someone developing or testing some
solution involving btrfs?

The Ganglia framework uses rrdtool to graph metric data and present it
alongside other system data (e.g. to see disk IO rates, CPU load, cache
activity all on the same graph) so it could provide some useful insights
into any performance testing of btrfs.  Even better, using rrdtool, you
can overlay some btrfs metric on the same graph as a system metric (e.g.
IO request sizes)


>    If you really want to, you can get your hands into the filesystem
> structures on a read-only (and non-locked) basis using the
> BTRFS_IOC_TREE_SEARCH ioctl, and the FS structures are documented at
> [1]. However, that's generally going to be pretty ugly, and most
> likely pretty slow for many operations at the subvolume level.
> 
>    If you want anything on a per-subvolume basis, then you'll have to
> wait for Arne to finish the work on quotas.
> 

Initially, I could just start with some simple metric (even just
retrieving the btrfs UUID) as a proof-of-concept, and then add more
stuff later, for example, when Arne has the quota work in a stable form.
