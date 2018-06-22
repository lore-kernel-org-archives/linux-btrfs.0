Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54099 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934062AbeFVQQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 12:16:34 -0400
MIME-Version: 1.0
Message-ID: <trinity-c9622916-720e-47e2-a9d3-b07a91ed3bf3-1529684129414@3c-app-mailcom-bs09>
From: "Su Yue" <Damenly_Su@gmx.com>
To: "Hugo Mills" <hugo@carfax.org.uk>
Cc: "Hans van Kranenburg" <hans.van.kranenburg@mendix.com>,
        "Nikolay Borisov" <nborisov@suse.com>,
        "Su Yue" <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add more details while checking tree block
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Jun 2018 18:15:29 +0200
In-Reply-To: <20180622154030.GG28972@carfax.org.uk>
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
 <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
 <06086fd3-f28b-5cc7-f3c6-3fca659b2fa0@mendix.com>
 <20180622154030.GG28972@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Sent: Friday, June 22, 2018 at 11:40 PM
> From: "Hugo Mills" <hugo@carfax.org.uk>
> To: "Hans van Kranenburg" <hans.van.kranenburg@mendix.com>
> Cc: "Nikolay Borisov" <nborisov@suse.com>, "Su Yue" <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs: Add more details while checking tree block
>
> On Fri, Jun 22, 2018 at 05:26:02PM +0200, Hans van Kranenburg wrote:
> > On 06/22/2018 01:48 PM, Nikolay Borisov wrote:
> > > 
> > > 
> > > On 22.06.2018 04:52, Su Yue wrote:
> > >> For easier debug, print eb->start if level is invalid.
> > >> Also make print clear if bytenr found is not expected.
> > >>
> > >> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> > >> ---
> > >>  fs/btrfs/disk-io.c | 8 ++++----
> > >>  1 file changed, 4 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > >> index c3504b4d281b..a90dab84f41b 100644
> > >> --- a/fs/btrfs/disk-io.c
> > >> +++ b/fs/btrfs/disk-io.c
> > >> @@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> > >>  
> > >>  	found_start = btrfs_header_bytenr(eb);
> > >>  	if (found_start != eb->start) {
> > >> -		btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
> > >> -			     found_start, eb->start);
> > >> +		btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",
> > > 
> > > nit: I'd rather have the want/have in brackets (want %llu have% llu)
> > 
> > From a user support point of view, this text should really be improved.
> > There are a few places where 'want' and 'have' are reported in error
> > strings, and it's totally unclear what they mean.
> > 
> > Intuitively I'd say when checking a csum, the "want" would be what's on
> > disk now, since you want that to be correct, and the "have" would be
> > what you have calculated, but it's actually the other way round, or
> > wasn't it? Or was it?
> > 
> > Every time someone pastes such a message when we help on IRC for
> > example, there's confusion, and I have to look up the source again,
> > because I always forget.
> > 
> > What about (%llu stored on disk, %llu calculated now) or something similar?
> 
>    Yes, definitely this. I experience the same confusion as Hans, and
> I think a lot of other people do, too. I usually read "want" and
> "have" the wrong way round, so more clarity would be really helpful.
> 
Thanks for the response. I will try to think up a "proper" description.

Su
>    Hugo.
> 
> > >> +			     eb->start, found_start);
> > >>  		ret = -EIO;
> > >>  		goto err;
> > >>  	}
> > >> @@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> > >>  	}
> > >>  	found_level = btrfs_header_level(eb);
> > >>  	if (found_level >= BTRFS_MAX_LEVEL) {
> > >> -		btrfs_err(fs_info, "bad tree block level %d",
> > >> -			  (int)btrfs_header_level(eb));
> > >> +		btrfs_err(fs_info, "bad tree block level %d on %llu",
> > >> +			  (int)btrfs_header_level(eb), eb->start);
> > >>  		ret = -EIO;
> > >>  		goto err;
> > >>  	}
> > >>
> > 
> 
> -- 
> Hugo Mills             | "There's a Martian war machine outside -- they want
> hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                           Stephen Franklin, Babylon 5
> 
