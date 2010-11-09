From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Questions regarding COW-related behaviors
Date: Tue, 9 Nov 2010 20:37:06 +0100
Message-ID: <201011092037.06382.kreijack@libero.it>
References: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com> <20101108224537.GA8950@flcl.lan> <1FAB8D40-6A0E-4E90-A9D9-3FB2D1656377@gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1FAB8D40-6A0E-4E90-A9D9-3FB2D1656377@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 09 November, 2010, Jo=E3o Eduardo Lu=EDs wrote:
> > The old tree is discarded unless the user requested a snapshot of i=
t.
> >=20
> > Every time btrfs updates the roots is a new generation. Some data
> > structures have "generation" fields, indicating the generation in w=
hich
> > they were most recently changed. This is mostly used to verify the
> > filesystem is correct, but it's also possible to scan the generatio=
n
> > fields and find out which files have changed.
>=20
> As Goffredo Baroncelli explained in a previous reply to my questions,=
 the=20
"find-new" command will search through keys with type BTRFS_EXTENT_DATA=
_TYPE.=20
This command does print several changes to the same files throughout hi=
story=20
since a given generation. My new question to this is rather simple: doe=
s BTRFS=20
actually keep the data from this generations to which "find-new" has ac=
cess,=20
or is it only able to access information that records this changes?
>=20

Btrfs stores the info in a btree. With the exception of the leaf, every=
 block=20
of the tree contains a list of a pair of key, pointer defined by the st=
ruct=20
btrfs_key_ptr:

struct btrfs_disk_key {
        __le64 objectid;
        u8 type;
        __le64 offset;
} __attribute__ ((__packed__));

struct btrfs_key_ptr {
        struct btrfs_disk_key key;
        __le64 blockptr;
        __le64 generation;
} __attribute__ ((__packed__));

The generation field, contains the info in which you are interested.

So I think that the correct answer of your question is the second one.

Regards
G.Baroncelli

--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
