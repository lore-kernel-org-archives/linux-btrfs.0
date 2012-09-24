Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:58381 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2IXOgs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:48 -0400
Received: by dady13 with SMTP id y13so166427dad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 07:36:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120924120232.GB14582@twin.jikos.cz>
References: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
	<20120921152051.GU17430@twin.jikos.cz>
	<505FCC96.8030703@oracle.com>
	<20120924120232.GB14582@twin.jikos.cz>
Date: Mon, 24 Sep 2012 08:36:47 -0600
Message-ID: <CAE5mzvh7qx1m-6DhaNe5LH-JpFwUpNxtsC9VKM-deJ3GwFGn5g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: btrfs subvolume delete could delete subvolumes
From: cwillu <cwillu@cwillu.com>
To: dave@jikos.cz, Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 6:02 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Sep 24, 2012 at 10:59:34AM +0800, Anand Jain wrote:
>> > Yes, this is useful, thanks. I'm thinking if it's ok to stop on
>> > first error, ie. when the subvolume does not exist or is a directory.
>>
>>  I am fine with either ways. I shall just keep it as it is as of now.
>
> Yes, I'm ok with that. The usecase I had in mind was something like
>
>   btrfs subvol del *
>
> but I should know the dir I'm in and what I'm doing there, errors are
> to be expected.

For what it's worth, rmdir's behaviour is to continue after errors
(i.e., "mkdir 1; mkdir 3; rmdir 1 2 3" deletes 1 and 3, and exits with
a non-zero exit code); unless there's a good reason to do otherwise,
matching that behaviour is probably best.
