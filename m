Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35966 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754163AbdDMOio (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 10:38:44 -0400
Received: by mail-lf0-f47.google.com with SMTP id s141so30690181lfe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 07:38:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$4dffc$4cc24d99$2c0f0eb0$3d6bddb5@cox.net>
References: <20170411163340.GJ2455@edanaher.net> <pan$4dffc$4cc24d99$2c0f0eb0$3d6bddb5@cox.net>
From: Noah Massey <noah.massey@gmail.com>
Date: Thu, 13 Apr 2017 10:38:02 -0400
Message-ID: <CADfjVrixFnEKAh2MYarsOLkf5yHrxRbd1EXJ6FnQMdpP9_2sQQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: send-dump: always print a space after path
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Evan Danaher <github@edanaher.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 12, 2017 at 7:05 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Evan Danaher posted on Tue, 11 Apr 2017 12:33:40 -0400 as excerpted:
>
>> I was shocked to discover that 'btrfs receive --dump' doesn't print a
>> space after long filenames, so it runs together into the metadata; for
>> example:
>>
>> truncate        ./20-00-03/this-name-is-32-characters-longsize=0
>>
>> This is a trivial patch to add a single space unconditionally, so the
>> result is the following:
>>
>> truncate        ./20-00-03/this-name-is-32-characters-long size=0
>>
>> I suppose this is technically a breaking change, but it seems unlikely
>> to me that anyone would depend on the existing behavior given how
>> unfriendly it is.
>>
>> Signed-off-by: Evan Danaher <github@edanaher.net>
>> ---
>
> I'm not a dev so won't attempt to comment on the patch itself, but it's
> worth noting that according to kernel patch submission guidelines (which
> btrfs-progs use as well) on V2+ patch postings, there should be a short,
> often one-line per version, summary of what changed between versions.
> This helps both reviewers and would-be patch-using admins such as myself
> understand how a patch is evolving, as well as for reviewers preventing
> unnecessary work when re-reviewing a new version of a patch previously
> reviewed in an earlier version.
>
> On patch series this summary is generally found in the 0/N post, while on
> individual patches without a 0/N, it's normally found below the first ---
> delimiter, so as to avoid including the patch history in the final merged
> version comment.

To be specific, something like
> ---
>
>v2: fixed an off-by-one error which caused padding to be 33 characters for short paths
> ---

instead of the email tail you currently appended (for future reference).
FWIW, I'm fine with you adding my 'Reviewed-by', but I don't think it
carries much weight yet. :-)

--
Noah
