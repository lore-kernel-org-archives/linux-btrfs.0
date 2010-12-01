From: C Anthony Risinger <anthony@extof.me>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 10:52:20 -0600
Message-ID: <AANLkTi=h=gh-8O6cdSHD=SVgdqb5JnCTX8fvRDu=F3Pr@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<20101201163800.GA4087@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201163800.GA4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 10:38 AM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
> On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
>> =3D=3D=3D Quotas =3D=3D=3D
>>
>> This is a huge topic in and of itself, but Christoph mentioned wanti=
ng to have
>> an idea of what we wanted to do with it, so I'm putting it here. =A0=
There are
>> really 2 things here
>>
>> 1) Limiting the size of subvolumes. =A0This is really easy for us, j=
ust create a
>> subvolume and at creation time set a maximum size it can grow to and=
 not let it
>> go farther than that. =A0Nice, simple and straightforward.
>>
>> 2) Normal quotas, via the quota tools. =A0This just comes down to ho=
w do we want
>> to charge users, do we want to do it per subvolume, or per filesyste=
m. =A0My vote
>> is per filesystem. =A0Obviously this will make it tricky with snapsh=
ots, but I
>> think if we're just charging the diff's between the original volume =
and the
>> snapshot to the user then that will be the easiest for people to und=
erstand,
>> rather than making a snapshot all of a sudden count the users curren=
tly used
>> quota * 2.
>
> =A0 This is going to be tricky to get the semantics right, I suspect.
>
> =A0 Say you've created a subvolume, A, containing 10G of Useful Stuff
> (say, a base image for VMs). This counts 10G against your quota. Now,
> I come along and snapshot that subvolume (as a writable subvolume) --
> call it B. This is essentially free for me, because I've got a COW
> copy of your subvolume (and the original counts against your quota).
>
> =A0 If I now modify a file in subvolume B, the full modified section
> goes onto my quota. This is all well and good. But what happens if yo=
u
> delete your subvolume, A? Suddenly, I get lumbered with 10G of extra
> files. =A0Worse, what happens if someone else had made a snapshot of =
A,
> too? Who gets the 10G added to their quota, me or them? What if I'd
> filled up my quota? Would that stop you from deleting your copy,
> because my copy can't be charged against my quota? Would I just end u=
p
> unexpectedly 10G over quota?
>
> =A0 This is a whole gigantic can of worms, as far as I can see, and I
> don't think it's going to be possible to implement quotas, even on a
> filesystem level, until there's some good and functional model for
> dealing with all the implications of COW copies. :(

i'd expect that as a separate user, you should both be whacked 10G.
imo, the whole benefit of transparent COW is to the administrators
advantage, thus i would even think the _uncompressed_ volume size
would go against quota (which could possibly be artificially inflated
to account for the space saving of compression).  users just need a
nice steadily predictable number to monitor.

thought maybe these users could be grouped, such that the COW'ed
portions of the files they share are balanced across each users quota,
but this would have to be a soprt of "opt in" thing else you get the
wild fluctuations because of other user's actions.  additionally, some
users could be marked as "system", where COW'ing their subvol results
in 0 quota -- you only pay for what you change -- but if the system
subvol gets removed, then you pay for it all.  in this way you would
have to keep reusing system subvols to get any advantage as a regular
user.

i dont know the existing systems though so i dont know what it would
take to do such balancing.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
