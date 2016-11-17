Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbcKQVuH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 16:50:07 -0500
Subject: Re: [Bug 186671] New: OOM on system with just rsync running 32GB of
 ram 30GB of pagecache
To: E V <eliventer@gmail.com>
References: <bug-186671-27@https.bugzilla.kernel.org/>
 <20161103115353.de87ff35756a4ca8b21d2c57@linux-foundation.org>
 <b5b0cef0-8482-e4de-cb81-69a4dd3410fb@suse.cz>
 <CAJtFHUQcJKSnyQ7t7-eDpiF2C+U23+iWpZ+X6fGEzN8qdbzmtA@mail.gmail.com>
 <a8cf869e-f527-9c65-d16d-ac70cf66472a@suse.cz>
 <CAJtFHUQgkvFaPdyRcoiV-m5hynDGo2qXfMXzZvGahoWp2LL_KA@mail.gmail.com>
 <bbcd6cb7-3b73-02e9-0409-4601a6f573f5@suse.cz>
 <CAJtFHUSka8nbaO5RNEcWVRi7VoQ7UORWkMu_7pNW3n_9iRRdew@mail.gmail.com>
 <CAJtFHUTn9Ejvyj3vJkqnsLoa6gci104-TPu5viG=epfJ9Rk_qg@mail.gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        bugzilla-daemon@bugzilla.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <4c85dfa5-9dbe-ea3c-7816-1ab321931e1c@suse.cz>
Date: Thu, 17 Nov 2016 22:49:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAJtFHUTn9Ejvyj3vJkqnsLoa6gci104-TPu5viG=epfJ9Rk_qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/16/2016 02:39 PM, E V wrote:
> System panic'd overnight running 4.9rc5 & rsync. Attached a photo of
> the stack trace, and the 38 call traces in a 2 minute window shortly
> before, to the bugzilla case for those not on it's e-mail list:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=186671

The panic screenshot has only the last part, but the end marker says
it's OOM with no killable processes. The DEBUG_VM config thus didn't
trigger anything, and still there's tons of pagecache, mostly clean,
that's not being reclaimed.

Could you now try this?
- enable CONFIG_PAGE_OWNER
- boot with kernel option: page_owner=on
- after the first oom, "cat /sys/kernel/debug/page_owner > file"
- provide the file (compressed, it will be quite large)

Vlastimil

