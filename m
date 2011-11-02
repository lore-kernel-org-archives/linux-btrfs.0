From: David Sterba <dave@jikos.cz>
Subject: Re: Warnings and crash
Date: Thu, 3 Nov 2011 00:02:31 +0100
Message-ID: <20111102230231.GM12759@twin.jikos.cz>
References: <20111101024957.GH4468@shiny> <20111101125654.GF12759@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101125654.GF12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

This one happened again, exactly same sequence of warnings and the crash
at the end (same stack traces). It was in integration-scrub branch, ie.
with all fixes on top.

(I have captured sysrq-w, /proc/pid/stack of all processes and have the
dmesg logs if anybody is interested.)


david
