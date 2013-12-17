Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab3LQP1d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:27:33 -0500
Date: Tue, 17 Dec 2013 16:27:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix use of uninitialized err variable
Message-ID: <20131217152731.GR6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386963574-14467-1-git-send-email-fdmanana@gmail.com>
 <20131216143440.GE6498@twin.jikos.cz>
 <CAL3q7H5Eu8UQ-6zvsTB8omTMh-iMKAONYV7QEvRKbcMnyJ1U-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAL3q7H5Eu8UQ-6zvsTB8omTMh-iMKAONYV7QEvRKbcMnyJ1U-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 05:03:25PM +0000, Filipe David Manana wrote:
> On Mon, Dec 16, 2013 at 2:34 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Fri, Dec 13, 2013 at 07:39:34PM +0000, Filipe David Borba Manana wrote:
> >> >From the compiler:
> >>
> >> fs/btrfs/file.c: In function ‘prepare_pages.isra.18’:
> >> fs/btrfs/file.c:1265:6: warning: ‘err’ may be used uninitialized in this function [-Wuninitialized]
> >
> > My gcc 4.8.1 does not see this warning, nor do I while inspecting the
> > souces in current next-master.
> 
> Here it's gcc 4.6.3.

I've seen that some versions of gcc produce bogus warnings of that sort
and manual review is needed, but I haven't found a code path that would
lead to uninitialized use of err.

The warning points to

1259                 if (i == 0)
1260                         err = prepare_uptodate_page(pages[i], pos,
1261                                                     force_uptodate);
1262                 if (i == num_pages - 1)
1263                         err = prepare_uptodate_page(pages[i],
1264                                                     pos + write_bytes, false);
1265                 if (err) {
^^^^

1266                         page_cache_release(pages[i]);
1267                         faili = i - 1;
1268                         goto fail;
1269                 }

But the loop starts from i = 0 and the variable is initialized before
the check. So ti's gcc that does not see that, not a real error.
