Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:32967 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbbC0Dfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 23:35:41 -0400
Received: by pdnc3 with SMTP id c3so83116203pdn.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 20:35:41 -0700 (PDT)
Date: Fri, 27 Mar 2015 11:34:32 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Chris Mason <clm@fb.com>, fdmanana@gmail.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: I think "btrfs: fix leak of path in btrfs_find_item" broke
 stable trees ...
Message-ID: <20150327033432.GB16812@dhcp-13-216.nay.redhat.com>
References: <55137BE2.80603@redhat.com>
 <CAL3q7H4fYq4K2rAT401QKSYKjRyaZwHDVSg6YZ0P=XU_31fLFQ@mail.gmail.com>
 <5514137E.6080804@redhat.com>
 <1427381284.28930.5@mail.thefacebook.com>
 <55143DD7.2020608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55143DD7.2020608@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 12:11:51PM -0500, Eric Sandeen wrote:
> On 3/26/15 9:48 AM, Chris Mason wrote:
> > On Thu, Mar 26, 2015 at 10:11 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> ...
> 
> >>>>  9c4f61f btrfs: simplify insert_orphan_item
> >>>>
> >>>>  made the whole path alloc/free go away.
> >>
> >> so I think there's no need for my patch; may as well just send the above to stable
> >> and fix it that way, as long as 9c4f61f is deemed safe & correct, I think.
> > 
> > Nice catch, thanks Eric. 9c4f61f looks fine for stable to me, but
> > since he's already testing on stable, I talked Eric into giving it a
> > pass through xfstests before I send it up.
> > 
> > -chris
> 
> ./check -g auto on 3.19-stable-ish seems fine-ish.  Certainly no worse w/ the patch added :)
> 
> Failures: btrfs/010 btrfs/017 btrfs/078 generic/015 generic/039 generic/040 generic/041 generic/065 generic/066 generic/071 generic/204
> Failed 11 of 202 tests

Just FYI.

I think generic/204 is a test case issue, _filter_mkfs failed to print
isize and dbsize for btrfs and test failed because of divide by zero
error.

--- /dev/fd/63	2015-03-25 12:17:05.987107715 -0400
+++ results/generic/204.out.bad		      2015-03-25 12:17:05.423101244 -0400
@@ -1,2 +1,3 @@
 QA output created by 204
 +./tests/generic/204: line 76: space / (isize + dbsize): division by 0 (error token is ")")
  *** done

I'm working a patch for fstests.

Eryu
