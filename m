Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:42439 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbGPDo0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 23:44:26 -0400
Received: by vnbf62 with SMTP id f62so6707730vnb.9
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 20:44:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
	<CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
	<CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com>
Date: Wed, 15 Jul 2015 21:44:25 -0600
Message-ID: <CAJCQCtTYWQO+7yLLBb0_+Ku=xYxcpgDwk53Ki_mtArMtXuCBNA@mail.gmail.com>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 9:12 PM, Paul Harvey <csirac2@gmail.com> wrote:
> On 16 July 2015 at 11:35, Chris Murphy <lists@colorremedies.com> wrote:

>> How is all of this backed up properly? How is it restored properly? I
>> think recursive snapshotting and subvolume deletion is not a good
>> idea. I think it's a complicated and inelegant work around for
>> improper subvolume organization.
>
> I for one would love to see authoritative documentation on "proper"
> subvolume organization.

The choice of "improper" wasn't ideal on my part. There's nothing
directly wrong with nested subvolumes. But if you then combine them
with snapshots and rollbacks, there are consequences that include more
complication. If more than one things is doing snapshots and
rollbacks, it requires some rules as to who can snapshot what and
where those things go in order to avoid being snapshot again by some
other tool, and then how things get reassembled. There are different
kinds of rollbacks so that needs some rules or it'll just lead to
confusion.


> I was completely lost when writing snazzer and
> have so far received very little guidance or even offers of opinions
> on this ML.

A couple of developers have suggested the folly of nested subvolumes
several times. Discovering the consequences of organizing subvolumes
is a work in progress. I've mentioned a couple times over the years
that distros are inevitably going to end up with fragmented and
mutually incompatible approaches if they don't actively engage each
other cooperatively. And that's turned out to be correct as Fedora,
Ubuntu and SUSE all do things differently with their Btrfs
organization.



> I've had to create my own logic in my scripts that automatically walk
> all subvolumes on all filesystems for the simple reason that
> explicitly enumerating it all for dozens of servers becomes a
> significant administration burden.
>
> I have different retention needs for /var (particularly /var/cache)
> than I do for /home, for example, so carving up my snapshots so that I
> can easily drop them from those parts of my filesystems which have a
> high churn rate (= more unique extents, occupying a lot of disk) and
> yet aren't as important (I need to retain fewer of them) is very
> useful.

At the moment, I like the idea of subvolumes pretty much only at the
top level of the file system (subvolid 5), and I like the naming
convention suggested here:
http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
under the section "What We Propose"

I don't really like the colons because those are special character so
now I have to type three characters for each one of those. But anyway
those then get assembled in FHS form via fstab using subvol= or
subvolid= mount option, or whatever replaces fstab eventually.

This way you can snapshot different subvolumes at different rates with
different cleanup policies while keeping all of them out of the
normally mounted FHS path. A side plus is that this also puts old
libraries outside the FHS path, sort of like they're in a jail.



-- 
Chris Murphy
