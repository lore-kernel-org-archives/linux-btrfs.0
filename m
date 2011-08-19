From: David Sterba <dave@jikos.cz>
Subject: Re: bonnie triggers and endless numbers of stack traces
Date: Sat, 20 Aug 2011 01:45:19 +0200
Message-ID: <20110819234519.GJ20461@twin.jikos.cz>
References: <j2m3ud$u8e$1@dough.gmane.org>
 <4E4EBB57.3040209@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4EBB57.3040209@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2011 at 03:36:55PM -0400, Josef Bacik wrote:
> This is being worked on, if you really don't like it pull my git tree
> and test it out and see if the errors go away
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git

pulled on top of latest linus', with top commit:
"Btrfs: fix space leak when we fail to make an allocation"

but I still see it, xfstests/013.


david
