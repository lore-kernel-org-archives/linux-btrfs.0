Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:35576 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3AWSQM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 13:16:12 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130123181611.EGCA17456.eastrmfepo201.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 23 Jan 2013 13:16:11 -0500
Message-ID: <510028EA.7090305@czarc.net>
Date: Wed, 23 Jan 2013 13:16:10 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, Nageswara R Sastry <nasastry@in.ibm.com>,
        danny.kukawka@bisect.de, chris.mason@fusionio.com
Subject: Re: [PATCH 01/13] btrfs-progs: btrfs-image.c: Added NULL pointer
 check.
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <1358715858-4469-2-git-send-email-gene@czarc.net> <20130121155630.GI19967@twin.jikos.cz>
In-Reply-To: <20130121155630.GI19967@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2013 10:56 AM, David Sterba wrote:
> On Sun, Jan 20, 2013 at 04:04:06PM -0500, Gene Czarcinski wrote:
>> >From: Nageswara R Sastry<nasastry@in.ibm.com>
>> >
>> >Check for the return value of 'open_ctree()' before dereferencing it.
>> >
>> >--- a/btrfs-image.c
>> >+++ b/btrfs-image.c
>> >@@ -491,6 +491,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
>> >  	int ret;
>> >  
>> >  	root = open_ctree(input, 0, 0);
>> >+	BUG_ON(!root);
> Bug_on is not the right fix here, I prefer a more extensive fix
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15305
>
> which prints a message and exits.
>
The above patch is 1 of 4 that were submitted.  Should those other three 
be included also.  I did a couple of spot checks and the changes were 
not picked up in another patch.

A couple of things bother me about these 4 patches.  First of all, 
nobody commented about them on this mailing list --- either good or 
bad.  Second, if the descriptions and code is at all accurate, why were 
these patches not included in the "flury" of patches applied later in 
the year to bring btrfs-progs more up-to-date?

These patches may "look good" but almost none of the changes will apply 
to "integration-20130121" or "91d9eec".
So some effort will be needed to refit/rebase these patches.  I am 
willing to do that if there is some agreement that this should be done.  
Of the 4 patches, the one addressing segfaults is the most serious.  The 
others deal with simple problems including one which changes spaces to 
tab characters.

Gene
