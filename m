From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: strange btrfs sub list output
Date: Tue, 31 May 2011 20:50:34 +0200
Message-ID: <4DE5387A.7080704@gmail.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com> <20110527091224.GA15627@carfax.org.uk> <chaz20110527093029.GA30613@seebyte.com> <20110527094523.GA12089@carfax.org.uk> <chaz20110527113010.GA12775@seebyte.com> <4DDF8FE0.9040107@gmail.com> <20110531100014.GA12396@yahoo.fr> <BANLkTikWE6b8nO7azgrCVhdZZ8b0ZfneVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephane Chazelas <stephane_chazelas@yahoo.fr>,
	Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@xtfx.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikWE6b8nO7azgrCVhdZZ8b0ZfneVg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 31.05.2011 19:40, C Anthony Risinger wrote:
> On Tue, May 31, 2011 at 5:00 AM, Stephane Chazelas
> <stephane_chazelas@yahoo.fr> wrote:
>> 2011-05-27 13:49:52 +0200, Andreas Philipp: [...]
>>>> Thanks, I can understand that. What I don't get is how one
>>>> creates a subvol with a top-level other than 5. I might be
>>>> missing the obvious, though.
>>>>
>>>> If I do:
>>>>
>>>> btrfs sub create A btrfs sub create A/B btrfs sub snap A
>>>> A/B/C
>>>>
>>>> A, A/B, A/B/C have their top-level being 5. How would I get a
>>>> new snapshot to be a child of A/B for instance?
>>>>
>>>> In my case, 285, was not appearing in the btrfs sub list
>>>> output, 287 was a child of 285 with path "data" while all I
>>>> did was create a snapshot of 284 (path
>>>> u6:10022/vm+xfs@u8/xvda1/g8/v3/data in vol 5) in
>>>> u6:10022/vm+xfs@u8/xvda1/g8/v3/snapshots/2011-03-30
>>>>
>>>> So I did manage to get a volume with a parent other than 5,
>>>> but I did not ask for it.
>> [...]
>>> Reconsidering the explanations on btrfs subvolume list in this
>>> thread I get the impression that a line in the output of btrfs
>>> subvolume list with top level other than 5 indicates that the
>>> backrefs from one subvolume to its parent are broken.
>>>
>>> What's your opinion on this?
>> [...]
>>
>> Given that I don't really get what the parent-child relationship
>> means in that context, I can't really comment.
>>
>> In effect, the snapshot had been created and was attached to the
>> right directory (but didn't appear in the sub list), and there
>> was an additional "data" volume that I had not asked for nor
>> created that had the snapshot above as parent and that did appear
>> in the sub list.
>>
>> It pretty much looks like a bug to me, I'd like to understand
>> more so that I can maybe try and avoid running into it again.
>
> i'm actually really interested in the conclusion to this thread
> because i _want_ to create subvols with a new parent ... i didn't
> realize this wasn't possible (nor the mount option) until reading
> this thread. this would give me a little more flexibility with
> initcpio hooks and the like vs. packing the btrfs root with tons of
> hidden files [subvols] or using IDs directly ...
>
> i tried absolutely everything i could think of to reproduce this
> but all subvols ended up having a top level id of `5`.
>
> ... so, is there any known way to _purposefully_ create parented
> subvols with the current tools?
Hopefully, I can help clarify this a little bit. In fact, this is the
'usual' case. With the attached patch to the master branch of
btrfs-progs-unstable you can 'watch' how the btrfs subvolume list
command builds the full path of the listed subvolumes. Additionally,
it gives you the IDs of the parent subvolumes. See the following example.

ID 256 top level 5 path test1
ID 257 top level 256 path test1.1
ID 257 top level 5 path test1/test1.1
ID 258 top level 5 path test2
ID 259 top level 258 path test2.1
ID 259 top level 5 path test2/test2.1

- From the second line you see that subvolume ID 256 really is ID 257's
parent. Additionally, only test1 and test2 have parent ID 5 or in your
terminology are in the btrfs root.

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..e75d6cf 100644
- --- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -248,6 +248,9 @@ static int resolve_root(struct root_lookup *rl,
struct root_info *ri)
                        top_id = next;
                        break;
                }
+
+               printf("ID %llu top level %llu path %s\n",
ri->root_id, next,
+                              full_path);
        }
        printf("ID %llu top level %llu path %s\n", ri->root_id, top_id,
               full_path);
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN5Th6AAoJEJIcBJ3+XkgiWNQP/jsWQymukrgESfqndQvrJwl6
QZOe5y9IMmV8jBDPot4EAVAQhLrG2twA1ALVvj+DfD0Ks9VATpmnP4QB39XIWlNz
/cRxoUev/Z8a0zNnXXneUsbJ1rYx5vX6R0yzRWiZ6Yd0EZ9GCRp+HvPRs5NNGGIc
0NZCQk1BOe+MAovSQpUbRtyfd4JcxdPEYkt29VySu2wrD02MdXVyzohegCzmUZWv
ou8COpWvquPmNvYHfudVir6r4BSEfqpIEkkGY61yts00rnnPXuOh1uZQKGyDuK/S
2o6EOAN3SIONEWts7nx95/IjfAbVa/XUmj+bhr2xJspH4Q93tr8rDns0XCCN/GYY
xTfMMUFajZHOhv5qjbUF9BFLAU62eKdw4zCPAmed4f/klBcXZ/Ri1pIBwaJv3CTp
J3camkJBwmTiSwTIIl1qTOMypv0xT602uiiegnBe/UAzz59+cSLDyWFXBc2QQoTV
jhJiLd281kjPqEqALMNJOOZ0pQ6hDxOoBqg7cA5VEY9619coQE93H6UXgtd0E4YX
U32bO7WypGbgd3HuNDWd44p4gVYR/Mzu8symvjJDKg5iChLkBEmYyN8hAGryYhtO
mZBWntTxYPm+Twkf+ovAtVpLGV5Gr1kfGln5lsmsIn1bPW8ZnVbWIDhulD1lQSVw
Th5rDp6lY0ZBe4+mbOXy
=M8dp
-----END PGP SIGNATURE-----

