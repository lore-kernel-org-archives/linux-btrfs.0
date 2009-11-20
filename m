From: David Nicol <davidnicol@gmail.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Fri, 20 Nov 2009 13:24:42 -0600
Message-ID: <934f64a20911201124q2a42fddek87d3f8fe864b3c41@mail.gmail.com>
References: <200911201950.06662.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Chris Ball <cjb@laptop.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911201950.06662.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2009 at 12:50 PM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:

> Any comments ?
> BR
> G.Baroncelli


since COW semantics require touching directory entries all the way up
to the root of the subvolume, for transaction-intensive applications
it would make sense to provide something that works like "mkdir" but
creates a subvolume that will be mounted at a point rather than a
simple directory entry. To avoid contention serializing updates to the
root directory.  Is something like that already in place?
