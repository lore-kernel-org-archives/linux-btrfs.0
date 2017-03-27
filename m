Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38402 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdC0UHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 16:07:00 -0400
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Roman Mamedov <rm@romanrm.net>, Chris Murphy <lists@colorremedies.com>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
 <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
 <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
 <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
 <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
 <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
 <20170328005358.5d5366ef@natsu>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Moritz Sichert <moritz+linux@sichert.me>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5236e403-6f41-aae1-6e8a-ab04e3b98c89@mendix.com>
Date: Mon, 27 Mar 2017 22:06:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170328005358.5d5366ef@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/27/2017 09:53 PM, Roman Mamedov wrote:
> On Mon, 27 Mar 2017 13:32:47 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>> How about if qgroups are enabled, then non-root user is prevented from
>> creating new subvolumes?
> 
> That sounds like, if you turn your headlights on in a car, then in-vehicle air
> conditioner randomly stops working. :)
> 
> Two things only vaguely related from the end user's point of view.
> 
>> Or is there a way for a new nested subvolume to be included in its
>> parent's quota, rather than the new subvolume having a whole new quota
>> limit?
> 
> Either that, or a separate "allow non-root user subvolumes/snapshots creation"
> mount option. There is already one for deletion, after all.
> 
>        user_subvol_rm_allowed
>               Allow subvolumes to be deleted by a  non-root  user.   Use  with
>               caution.
> 

What are actual use cases for creating subvolumes by 'normal' users?

Does someone have an example?

Why is it possible at all, by default?

-- 
Hans van Kranenburg
