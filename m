Return-Path: <dsterba@suse.cz>
Date: Thu, 12 May 2016 11:22:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
	MarkFasheh <mfasheh@suse.de>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Idea on compatibility for old distributions
Message-ID: <20160512092212.GL29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
 <ff2d7c7e-26c7-46dd-1372-b40e79f53b88@redhat.com>
 <15f7b634-f173-d73f-5c17-8d9294f1efd7@cn.fujitsu.com>
 <20160512083755.GJ29353@suse.cz>
 <b746cf06-bafc-25e8-a684-710f481ff337@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b746cf06-bafc-25e8-a684-710f481ff337@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 04:51:22PM +0800, Qu Wenruo wrote:
> David Sterba wrote on 2016/05/12 10:37 +0200:
> > On Thu, May 12, 2016 at 08:57:47AM +0800, Qu Wenruo wrote:
> >> Thanks for the info.
> >>
> >> I also read the phoronix news yesterday.
> >> So for RHEL6 that's meaningless.
> >>
> >> But I'm not sure whether it's still meaningless for OpenSUSE, maybe
> >> David has some plan on it?
> >
> > No plans.
> >
> So the compatible layer patch is just to allow btrfs-progs to be 
> compiled on old distros?

Yes, but convert compatibility is with e2fsprogs while
FIEMAP_EXTENT_SHARED is kernel interface.
