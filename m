From: Zach Brown <zab@zabbo.net>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 15:50:07 -0400
Message-ID: <4F736B6F.2080805@zabbo.net>
References: <loom.20120328T160525-464@post.gmane.org> <20120328184204.GB1941@localhost.localdomain> <20120328185720.GC1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Danny Piccirillo <danny.piccirillo@member.fsf.org>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120328185720.GC1941@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


> but lets say O(log N/2) where N is the number of elements in the row.
> So in the situation I describe you are looking at having to do minimum
> of 29 reads, one for each row,

Hmm.

Levels are powers of two and are either full or empty.  So the total
item count tells you which levels are full or empty.

(gdb) print/t 1000000000
$3 = 111011100110101100101000000000

So no, definitely not reading 29 levels.

After realizing this, I have to be honest: I'm not finding your
hand-wavey dismissal of the technology convincing at all. :)

There's a *ton* of detail that they don't describe about how to actually
translate the logical notion of power-of-two node sizes into coherent
block IO that scales.  I don't doubt that it's possible.

I very much doubt that the required complexity and cpu cost in the
kernel would be worth it for generic file system users, though.  Hooo
boy, do I doubt it.

- z
