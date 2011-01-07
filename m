From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: 'open_ctree failed', unable to mount the fs
Date: Fri, 7 Jan 2011 15:02:09 -0500 (EST)
Message-ID: <84f68d319370863b2fed9181f93295b9.squirrel@webmail.jots.org>
References: <4D27631B.9020700@wpkg.org>
    <20110107190930.GA24059@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "Hugo Mills" <hugo-lkml@carfax.org.uk>,
	"Tomasz Chmielewski" <mangoo@wpkg.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110107190930.GA24059@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, January 7, 2011 2:09 pm, Hugo Mills wrote:
> On Fri, Jan 07, 2011 at 08:01:47PM +0100, Tomasz Chmielewski wrote:
>
>> I got a "power cycle", after which I'm no longer able to mount btrfs
>> filesystem:
[...]
> The forthcoming[1] btrfsck tool should handle that particular
> error, I believe.

I tried it with the btrfsck in the git repo (last week), and wound up
with... a brandy-new, blank btrfs partition.  Not *quite* what I was
looking for.  But at least it mounted.

-K




