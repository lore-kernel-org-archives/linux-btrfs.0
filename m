Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38683 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbCYLiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 07:38:20 -0400
Received: by igbqf9 with SMTP id qf9so22490635igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 04:38:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55129428.7090508@gmail.com>
References: <550E7917.5030602@gmail.com>
	<20150325011937.GB20767@twin.jikos.cz>
	<55129428.7090508@gmail.com>
Date: Wed, 25 Mar 2015 07:38:20 -0400
Message-ID: <CAGfcS_n1CyDMXdAu6eKuwszz+hBxnHdLpgxwW63TPs9k2zFDbQ@mail.gmail.com>
Subject: Re: snapshot destruction making IO extremely slow
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Marc Cousin <cousinmarc@gmail.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 25, 2015 at 6:55 AM, Marc Cousin <cousinmarc@gmail.com> wrote:
> On 25/03/2015 02:19, David Sterba wrote:
>> as it reads the pre/post snapshots and deletes them if the diff is
>> empty. This adds some IO stress.
>
> I couldn't find a clear explanation in the documentation. Does it mean
> that when there is absolutely no difference between two snapshots, one
> of them is deleted ? And that snapper does a diff between them to
> determine that ?
>

It seems like there should be some supported way of doing a diff on
two btrfs subvolumes.  There should be no need to recursively scan
trees if the heads of those trees are shared.  If I change one file at
the bottom of a 10 layer directory hierarchy, it should only take a
small number of reads to determine this.

The problem is that we don't have any functionality in kernel space to
do this (that I'm aware of), and we don't expose the necessary
information to userspace for it to do this smartly (again, as far as
I'm aware).

Maybe there would be some way to do it using btrfs send and parsing the output.

--
Rich
