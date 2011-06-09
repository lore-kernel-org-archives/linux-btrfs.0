From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/2] Btrfs: serialize flushers in reserve_metadata_bytes
Date: Thu, 9 Jun 2011 20:00:15 +0200
Message-ID: <20110609180015.GM12709@twin.jikos.cz>
References: <1307479449-14765-1-git-send-email-josef@redhat.com>
 <1307479449-14765-3-git-send-email-josef@redhat.com>
 <20110609094547.GK12709@twin.jikos.cz>
 <4DF0D20A.4040906@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF0D20A.4040906@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 09, 2011 at 10:00:42AM -0400, Josef Bacik wrote:
> We're not trying to be perfect here, we're trying to be fast :).

Be even faster with smp_rmb() :)


david
