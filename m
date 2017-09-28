Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:47756 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbdI1OMe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:12:34 -0400
Received: by mail-oi0-f44.google.com with SMTP id p187so2450321oif.4
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170918144005.GC29043@twin.jikos.cz>
References: <20170917235227.6452-1-nsteeves@gmail.com> <20170917235227.6452-3-nsteeves@gmail.com>
 <20170918144005.GC29043@twin.jikos.cz>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Thu, 28 Sep 2017 10:12:32 -0400
Message-ID: <CAD=QJKhkf=-URJOQtOWGaa9M6Vkm-mTqNf_nopdC=BKvxZyq+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] Remove misleading BCP 78 boilerplate
To: dsterba@suse.cz, Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 18 September 2017 at 10:40, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Sep 17, 2017 at 07:52:27PM -0400, Nicholas D Steeves wrote:
>> BCP 78 applies to RFC 6234, but sha224-256.c is Simplified BSD.
>>
>> This causes the following lintian error when building on Debian and
>> Debian derivatives:
>>
>>     E: btrfs-progs source: license-problem-non-free-RFC-BCP78
>>        tests/sha224-256.c
>>
>> Please consult the following email from debian-legal@lists.debian.org
>> for more information:
>>
>> https://lists.debian.org/debian-legal/2017/08/msg00004.html
>
> Thanks, this looks like I've copied too much from the RFC and was not
> aware of the BCP license issues. I believe the copyright notice(s) past
> the line mentioning the filename(s) should be enough to satisfy the
> licensing requirements and also the debian license checker.

Thank you for applying these so quickly, and for the new release :-)

Sincerely,
Nicholas
