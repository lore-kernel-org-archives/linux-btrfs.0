Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53591 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab3AORpH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 12:45:07 -0500
Received: by mail-oa0-f53.google.com with SMTP id j6so424745oag.12
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 09:45:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130115144912.GB5890@merlins.org>
References: <20130114173250.GA23026@merlins.org>
	<87libvaqlp.fsf@davidb.org>
	<20130115144912.GB5890@merlins.org>
Date: Tue, 15 Jan 2013 11:45:05 -0600
Message-ID: <CAKcLGm_GjuE0HUDn4Z3F27JWu86BMnPtb1uH42X4iSps7yf=ew@mail.gmail.com>
Subject: Re: Can moving data to a subvolume not take as long as a fully copy?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Marc MERLIN <marc@merlins.org>
Cc: David Brown <btrfs@davidb.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 8:49 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Jan 14, 2013 at 10:48:50PM -0800, David Brown wrote:
>> Why not make a snapshot of the root volume, and then delete the files
>> you want to move from the original root, and delete the rest of root
>> from the snapshot?
>
> Are a snapshot of the root volume and a subvolume effectively the same thing
> as far as btrfs sees them?
> Once I have that snapshot which I'll treat as a subvolume, can I then
> snapshot that snapshot/subvolume further?
>

Yes, the product of the btrfs snapshot command is a subvolume.
