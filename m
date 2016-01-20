Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38020 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcATLeG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 06:34:06 -0500
Subject: Re: Kernel 4.4.0 KVM guest on Btrfs locks up on snapshotting
To: Roman Mamedov <rm@romanrm.net>, bo.li.liu@oracle.com
References: <20160120030223.22cc3ae0@natsu>
 <20160120001944.GA9884@localhost.localdomain> <20160120100852.470479a6@natsu>
Cc: linux-btrfs@vger.kernel.org, kvm@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569F70AA.2030006@redhat.com>
Date: Wed, 20 Jan 2016 12:34:02 +0100
MIME-Version: 1.0
In-Reply-To: <20160120100852.470479a6@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20/01/2016 06:08, Roman Mamedov wrote:
> I don't get any ENOSPC errors on the host, also it doesn't seem to
> be a slowdown caused by disk I/O searching for free space, just a
> complete lock-up: I monitor the guest with 'ping', and when it
> happens, the ping responses stop immediately and do not return,
> also there is no reaction to any keypress in the KVM VNC window.

Can you go to the QEMU monitor (Ctrl-Alt-F2 typically, or just add
"-monitor stdio" to the QEMU command line) and type "info status"?

Paolo
