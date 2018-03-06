Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38447 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753606AbeCFMAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 07:00:49 -0500
Date: Tue, 6 Mar 2018 12:58:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
Message-ID: <20180306115827.GQ5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
 <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
 <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
 <8af18593-05ff-e24c-1c39-0492cce2c21b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8af18593-05ff-e24c-1c39-0492cce2c21b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 07:40:14PM +0800, Qu Wenruo wrote:
> On 2018年03月02日 19:00, Filipe Manana wrote:
> > On Fri, Mar 2, 2018 at 10:54 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >> On 2018年03月02日 18:46, Filipe Manana wrote:
> >>> On Fri, Mar 2, 2018 at 5:22 AM, Qu Wenruo <wqu@suse.com> wrote:
> >>>> Normally when specifying max_inline, we should normally limit it by
> >>>> uncompressed extent size, as it's the only thing user can control.
> >>>
> >>> Why does it matter that users can control it? Will they write less (or
> >>> more) data to files because stuff won't get inlined?
> >>> Why do they care about stuff getting inlined or not? That's an
> >>> implementation detail of btrfs to speed up access to file data and
> >>> save some space.
> >>
> >> Then why we still have max_inline mount option?
> > 
> > My comment was about deciding based on which size to make the decision
> > (compressed vs uncompressed).
> 
> The same thing, we have given user options to trigger the behavior, then
> we should give them *predictable* option to modify the behavior.
> 
> Not something confusing like current max_inline.
> 
> Either we give user max_inline and max_inline_compressed, or both follow
> max_inline.

I agree with Filipe and don't see a reason to limit the inlining
capabilities. Max inline exists to set the maximum file size that will
be considered for inlining, the rest is implementation detail.

In a similar way the compression can decide if the data will be
compressed, though the user has specified the mount option.

Adding another option (max_inline_compressed) does not necessarily
improve the situation. This requires the user to understand the values
it can have and how it interacts with other options.

I've been thinking about this patchset for a few days and still don't
think there's a problem we need to fix. We can certainly improve the
reporting, so the mount option value will be adjusted to the exact
inline limit and then printed to syslog. Additionally we can export the
value as sysfs file, and udate documentation.
