From: David Sterba <dsterba@suse.cz>
Subject: Re: Kernel BUG unable to handle kernel NULL pointer dereference
Date: Mon, 24 Oct 2011 13:22:59 +0200
Message-ID: <20111024112259.GE26547@ds.suse.cz>
References: <CAAeznTqh1W0W743WxTO+iUfajgsMw-A6abwr1fAZ6hWOJOnw2Q@mail.gmail.com>
 <CAKcLGm-+g9xy_aL2Z_F2VYG8qFsXonB7nutM1VSs5sqLZz2PGA@mail.gmail.com>
 <CAAeznTpDmT7NgZdAHh7uVPBnKtitr=SmLRvfFKrd_exG6XLE9w@mail.gmail.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTpDmT7NgZdAHh7uVPBnKtitr=SmLRvfFKrd_exG6XLE9w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 23, 2011 at 07:24:42PM +0100, Leonidas Spyropoulos wrote:
> On Sun, Oct 23, 2011 at 4:37 PM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
> > A patch was submitted by Sergei Trofimovich to address the issue with
> > handling a NULL pointer in btrfs_print_leaf.
> >
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg12021.html

afaik the patch should be enqueued for 3.2

> How can I track down the real problem? Any suggestions?

The preceding function in the stack was __btrfs_free_extent, there are 3
instances of btrfs_print_leaf() in that function, 2 of them relevant:

4470                                 printk(KERN_ERR "umm, got %d back from search"
4471                                        ", was looking for %llu\n", ret,
4472                                        (unsigned long long)bytenr);


4494 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
...
4511                         printk(KERN_ERR "umm, got %d back from search"
4512                                ", was looking for %llu\n", ret,
4513                                (unsigned long long)bytenr);
4514                         btrfs_print_leaf(extent_root, path->nodes[0]);
...
     #endif

and the third one without a pre-message

4481                 btrfs_print_leaf(extent_root, path->nodes[0]);
4482                 WARN_ON(1);
4483                 printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
4484                        "parent %llu root %llu  owner %llu offset %llu\n",
4485                        (unsigned long long)bytenr,
4486                        (unsigned long long)parent,
4487                        (unsigned long long)root_objectid,
4488                        (unsigned long long)owner_objectid,
4489                        (unsigned long long)owner_offset);


your original report does not contain any messages before the BUG
listing, so I'm not sure which one it is.

Supposed it's the 3rd, it's resulting from an error returned by

4429         ret = lookup_extent_backref(trans, extent_root, path, &iref,
4430                                     bytenr, num_bytes, parent,
4431                                     root_objectid, owner_objectid,
4432                                     owner_offset);

ret != 0 -> print leaf etc, a missing backref could be the problem here.

Are you able to trigger the BUG() repeatedly?


david
