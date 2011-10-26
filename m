From: Arne Jansen <sensille@gmx.net>
Subject: Re: [patch] Move nodesize/leafsize/sectorsize to fs_info
Date: Wed, 26 Oct 2011 16:47:15 +0200
Message-ID: <4EA81D73.8090005@gmx.net>
References: <CAKyAS7s1Xm3L_1QwptAKs61e0bc4s4z7k8jWo4SiujQFMSss0g@mail.gmail.com> <20111026133409.GA5914@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Peeters Simon <peeters.simon@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111026133409.GA5914@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2011 03:34 PM, David Sterba wrote:
> Hi,
>
> sorry for late reply. This patch tries to unify node-/leaf-/... sizes
> nad put it just into fs_info, but this assumes all trees share the same
> sizes. Unfortunatelly this is not true (once we allow big blocks; soon?).
>
> The root tree has a hardcoded size of 4k, see the __setup_root called
> with 4k in open_ctree:
>
> 1760         __setup_root(4096, 4096, 4096, 4096, tree_root,
> 1761                      fs_info, BTRFS_ROOT_TREE_OBJECTID);
>
> the other trees have size defined during mkfs. And only these trees
> share the size. You'd have to add exception to use 4k or ->leafsize
> depending on the tree being used. It's less error prone to always just
> the structure item as it will hold always the correct value, although
> there is some memory wasted.

The sizes get initialized to 4096, but after the super block is read,
these are replaced by those from the SB.

>
>  From the peformace POV, the ->leafsize etc items can cause cacheline
> bouncing when any of the code wants to access the item (and it's not
> that rare) for a different tree / cpu. But anyway with current
> performance status, this effect will be hardly measurable.
>
> On Sun, Aug 07, 2011 at 11:54:31PM +0200, Peeters Simon wrote:
>> [1] https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas
>
> I'd like to see how this idea was expected to be implemented, but
> there's no wiki to check.

It was indeed meant to get rid of the possibility to have different
sizes for different trees, as it just adds complexity. Chris mentioned
once that he does not intend to allow different sizes between trees,
thus the idea for this cleanup.

-Arne

>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

