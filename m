From: "Erwin van Londen" <erwin.vanlonden@hds.com>
Subject: btrfs for enterprise raid arrays
Date: Thu, 2 Apr 2009 21:34:38 -0700
Message-ID: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

While going through the archived mailing list and crawling along the wi=
ki I didn't find any clues if there would be any optimizations in Btrfs=
 to make efficient use of functions and features that today exist on en=
terprise class storage arrays.

One exception to that was the ssd option which I think can make a impro=
vement on read and write IO's however when attached to a storage array,=
 from an OS perspective, it doesn't really matter since it can't look b=
ehind the array front-end interface anyhow(whether it FC/iSCSI or any o=
ther).

There are however more options that we could think of. Almost all stora=
ge arrays these days have the capabilities to replicate volume (or part=
 of it in COW cases) either in the system or remotely. It would be hand=
y that if a Btrfs formatted volume could make use of those features sin=
ce this might offload a lot of the processing time involved in maintain=
ing these. The arrays already have optimized code to make these snapsho=
ts. I'm not saying we should step away from the host based snapshots bu=
t integration would be very nice.

=46urthermore some enterprise array have a feature that allows for full=
 or partial staging data in cache. By this I mean when a volume contain=
s a certain amount of blocks you can define to have the first X number =
of blocks pre-staged in cache which enables you to have extremely high =
IO rates on these first ones. An option related to the -ssd parameter c=
ould be to have a mount command say "mount -t btrfs -ssd 0-10000" so Bt=
rfs knows what to expect from the partial area and maybe can optimize t=
he locality of frequently used blocks to optimize performance.

Another thing is that some arrays have the capability to "thin-provisio=
n" volumes. In the back-end on the physical layer the array configures,=
 let say, a 1 TB volume and virtually provisions 5TB to the host. On wr=
ites it dynamically allocates more pages in the pool up to the 5TB poin=
t. Now if for some reason large holes occur on the volume, maybe a coup=
le of ISO images that have been deleted, what normally happens is just =
some pointers in the inodes get deleted so from an array perspective th=
ere is still data on those locations and will never release those alloc=
ated blocks. New firmware/microcode versions are able to reclaim that s=
pace if it sees a certain number of consecutive zero's and will reclaim=
 that space to the volume pool. Are there any thoughts on writing a low=
-priority tread that zeros out those "non-used" blocks?

Given the scalability targets of Btrfs it will most likely be heavily u=
sed in the enterprise environment once it reaches a stable code level. =
If we would be able to interface with these array based features that w=
ould be very beneficial.=20

=46urthermore one question also pops to mind and that's when looking at=
 the scalability of Btrfs and its targeted capacity levels I think we w=
ill run into problems with the capabilities of the server hardware itse=
lf. From what I can see now it will not be designed as a distributed fi=
le-system with integrated distributed lock manager to scale out over mu=
ltiple nodes. (I know Oracle is working on a similar thing but this mig=
ht get things more complicated than it already is.) This might impose s=
ome serious issues with recovery scenarios like backup/restore since it=
 will take quite some time to backup/restore a multi PB system when it =
resides on just 1 physical host even when we're talking high end P-seri=
es, I25K's or Superdome class.

I'm not a coder but am heavily involved in the storage industry for the=
 past 15 years so this is just some of the things I come across in real=
 life enterprise customer environments so these are just some of my min=
d spinnings.

There are some more however these would be best covered in another topi=
c.

Let me know your thoughts.

Kind regards,

Erwin van Londen
Systems Engineer
HITACHI DATA SYSTEMS
Level 4, 441 St. Kilda Rd.
Melbourne, Victoria, 3004
Australia
=A0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
