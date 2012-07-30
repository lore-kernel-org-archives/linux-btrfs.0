Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37978 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2G3URb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 16:17:31 -0400
Received: by pbbrp8 with SMTP id rp8so10362207pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 13:17:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvaccCm3GgHQ_Vj=1gZvecQJDbPhQC-shdODfYPx8QRVwQ@mail.gmail.com>
References: <CAHf9xvbz92KdUrXHhEFyEqwFhA97yTw7=10YC8YyCMxDZ20_Yw@mail.gmail.com>
	<CAB9VWqDS+zVku2diCYh08k=V_iT10fssRpEFcw9p8rn+dtaQqg@mail.gmail.com>
	<CAHf9xvbaWkM8EqeBA-z1HaFV56vtMfWjpZDp+OfUGu88nsOzug@mail.gmail.com>
	<CAHf9xvaj+uzWc39Hp5SLaVfevhwqvNXY9eWBY0Q-yT=7yPgS-w@mail.gmail.com>
	<CAB9VWqDj5c2Ds=zthKdUPfNyGELgaTmfj9UHf4uvqxMs4--9+Q@mail.gmail.com>
	<CAB9VWqAv-86CtAgitTD0BBaifomMGVsGZEnhaMsZ4DNV8DndFA@mail.gmail.com>
	<CAHf9xvYApp7yEmX7BCi1Y3Ut7hX2VDxAkJgAxNp-FtkQCBiXUQ@mail.gmail.com>
	<CAB9VWqAPvjyQ3EhcZQC59b0qcGr3QFozP60A0q+=FiRv3wxgbg@mail.gmail.com>
	<CAHf9xvaccCm3GgHQ_Vj=1gZvecQJDbPhQC-shdODfYPx8QRVwQ@mail.gmail.com>
Date: Mon, 30 Jul 2012 22:17:30 +0200
Message-ID: <CAB9VWqD9DYmLZ_5amskPSZwwBHu-Q+zYcQRuVcLdkPkwoKjfpw@mail.gmail.com>
Subject: Re: btrfs send/receive: if new inode ino is less than its new
 directory ino, incorrect path is sent
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 7:35 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Hi,
>> I did not apply the patch but instead added a check for dir != tmp_dir
>> only. The reason to not check for gen is that I have a rule in my
>> mind: I only pass the generation number to functions where I want to
>> know the *current* state. is_first_ref is for permanent state, the
>> return value never changes while sending. I could however not
>> reproduce the problem with test_1.sh, but it should fix it.
>
> I understand. I was not sure about dir_gen either. Since you call this
> function to check the permanent state in a particular root, it does
> not make sense to compare the generation.
>
>>>
>>> btrfs_test_2.sh
>>> The last test exposes an interesting issue: when a directory has a
>>> deleted reference recorded, this deleted reference is not added to the
>>> 'check_dirs' list. As a result, the upper directory (already
>>> orphanized) is not rmdir'd.
>> You'll find a commit in my repo to fix this. The problem was, that
>> moved directories do not get into the delete_refs loop and thus the
>> parent of the old location is never added to the check_dirs list.
>> I have force pushed to for-alex, if you have time I'd be happy if you
>> test again :)
> Thanks. It fixes the issue.
>
> ...and pls expect another mail from me with a long list of questions I
> accumulated:)
Do you have more bugs that you found or only questions? If you have
more bugs, it would be good if you could separate them from the mail
and probably send it earlier.

Regarding your earlier question: Yes, for-alex is meant to go upstream
before I leave. It will become for-chris and with a final pull
request.
>
> Thanks!
> Alex.
