Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35354 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaBNTQN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 14:16:13 -0500
Received: by mail-lb0-f182.google.com with SMTP id w7so9521986lbi.41
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 11:16:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140214185948.GB16073@twin.jikos.cz>
References: <1392403247-3627-1-git-send-email-jmaggard10@gmail.com>
	<20140214185948.GB16073@twin.jikos.cz>
Date: Fri, 14 Feb 2014 11:16:11 -0800
Message-ID: <CAKgsxVTfPyJUBzP4ASo=UOuFpLMVx_ZV_2LJ-mdMWY1h-kVvDw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: add dry-run option to restore command
From: Justin Maggard <jmaggard10@gmail.com>
To: dsterba@suse.cz, Justin Maggard <jmaggard10@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 14, 2014 at 10:59 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Feb 14, 2014 at 10:40:47AM -0800, Justin Maggard wrote:
>> Sometimes it is useful to see what btrfs restore is going to do
>> before provisioning enough external storage to restore onto.
>> Add a dry-run option so we can see what files and paths are found
>> by restore, without actually restoring any data.
>>
>> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
>
> Thanks, I've added a
>
> +       if (dry_run)
> +               printf("This is a dry-run, no files are going to be restored\n");
> +
>
> before the actual restoring starts so user knows.

Sounds good to me.  Thanks!
