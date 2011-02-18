From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 29302] New: Null pointer dereference with
 large max_sectors_kb
Date: Fri, 18 Feb 2011 11:56:03 -0800
Message-ID: <20110218115603.5f235b07.akpm@linux-foundation.org>
References: <bug-29302-10286@https.bugzilla.kernel.org/>
	<20110217153719.9ecc67df.akpm@linux-foundation.org>
	<20110218174315.GD5615@twin.jikos.cz>
	<1298056463-sup-4453@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	bugzilla-daemon <bugzilla-daemon@bugzilla.kernel.org>,
	bugme-daemon <bugme-daemon@bugzilla.kernel.org>,
	fox <fox@murder.cz>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298056463-sup-4453@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Feb 2011 14:16:12 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> Are there any more kernel messages involved before the oops starts? 

The full dmesg is in bugzilla. https://bugzilla.kernel.org/show_bug.cgi?id=29302
