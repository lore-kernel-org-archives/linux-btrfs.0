Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33131 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbcAEOF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 09:05:27 -0500
Date: Tue, 5 Jan 2016 05:03:27 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Runs the xor function if a Block has failed
Message-ID: <20160105050327.1ff85a20@gmail.com>
In-Reply-To: <20160105092236.GO4227@twin.jikos.cz>
References: <1451456916-16520-1-git-send-email-jpage.lkml@gmail.com>
	<20151230171826.GG4227@twin.jikos.cz>
	<20151230211544.32bc337e@gmail.com>
	<20160105092236.GO4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Jan 2016 10:22:36 +0100
David Sterba <dsterba@suse.cz> wrote:

> If the data a rerecovered, why is -EIO still returned? 

In the other places in the file where the code appears, the submitted
patch is all that is required to do the xor. I think we also need to
include the following line:
memcpy(pointers[nr_data], pointers[0], PAGE_SIZE);
and delete the "return EIO" statement which I believe appears to be a
placeholder for the xor function.
In the end the final patch should look something like this:
> -					 * TODO, we should redo the xor here.
>  					 */
> +					memcpy(pointers[nr_data], pointers[0], PAGE_SIZE);
> +					run_xor(pointers, rbio->nr_data - 1, PAGE_CACHE_SIZE); 
> - err = -EIO;

So, I was just going to send you the mail as it is written above, but I
decided to investigate. The commit in question that added the todo was
53b381b3abeb86f12787a6c40fee9b2f71edc23b. Unfortunately, it was not
submitted  by the original author, nor was it by any means a small
dedicated patch. It adds the entire file, without much comment or
explanation and has not been touched since. 

However, we can get some idea of what is expected by looking at line
2398 in raid56.c, where a similar case of raid 5 recovery is handled.

So what the patch described above does is deal with a scenario where
no q stripe or bad data block exists, and, we can only rebuild from the
p-stripe, in effect like a raid 5 recovery.

So, if you are satisfied with the above retouched change, I can modify
my original patch with your suggestions and my changes, and, I can
forward them to the list again.

> Also, I see some post-recovery steps eg. for the damaged P stripes
> (at label pstripes) and I'd expect something similar for the case
> you're fixing.

I believe that is the case because the other cases still have the q-
stripe available tor rebuild from, which requires cleanup afterwards,
but the raid5-like scenario above does not. Let me know if anything
else is needed.

> I'm not familiar with the raid56 implementation but the fix looks
> suspiciously trivial and I doubt that the xor was omitted out of
> laziness.

I guess we will never know.

Thanks
