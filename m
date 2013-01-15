Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35709 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3AOBN5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 20:13:57 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so2486051pbc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 17:13:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <91D14518-E06D-43C4-A4AE-111560B5A91F@colorremedies.com>
References: <CAPVzhpw6rc9VuSwhaPx8xhP02u-vAXoQW_1-odaTiyfcsQx0jw@mail.gmail.com>
	<91D14518-E06D-43C4-A4AE-111560B5A91F@colorremedies.com>
Date: Mon, 14 Jan 2013 22:13:57 -0300
Message-ID: <CAPVzhpzj=C+fj3TjXs4Ux_RaAMG5_6ncfh9vgGT2K8CEZcjzvA@mail.gmail.com>
Subject: Re: kernel call trace when deleting a huge file (which used all the
 space) with btrfs
From: Reartes Guillermo <rtguille@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am afraid it is reproducible with kernel 3.7.2-201.fc18.x86_64, with
the same procedure.

Cheers.

On Mon, Jan 14, 2013 at 12:25 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Jan 14, 2013, at 12:11 AM, Reartes Guillermo <rtguille@gmail.com>
> wrote:
>
>>
>>
>> Recently i have found some issues with BTRFS, i am using F18.
>
>
> For list reference, Fedora 18 ships with
> btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18, and
> kernel-3.6.10-4.fc18.x86_64, which is what your bug report shows.
>
> Is this reproducible with either kernel-3.7.2-201.fc18 or
> kernel-3.8.0-0.rc3.git0.1.fc19? Both are in koji.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
