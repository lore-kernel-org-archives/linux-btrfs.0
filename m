Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:46660 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbeHKXpc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 19:45:32 -0400
Received: by mail-oi0-f54.google.com with SMTP id y207-v6so21347840oie.13
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Aug 2018 14:10:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com> <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com> <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com> <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
 <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com> <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Sat, 11 Aug 2018 17:10:04 -0400
Message-ID: <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

19 hours later, still going extremely slowly and taking longer and
longer for progress made.  Main symptom is the mount process is
spinning at 100% CPU, interspersed with btrfs-transaction spinning at
100% CPU.
So far it's racked up 14h45m of CPU time on mount and an additional
3h40m on btrfs-transaction.

The current drop key changes every 10-15 minutes when I check it via
inspect-internal, so some progress is slowly being made.

I built the kernel with ftrace to see what's going on internally, this
is the pattern I'm seeing:

           mount-6803  [002] ...1 69023.970964: btrfs_next_old_leaf
<-resolve_indirect_refs
           mount-6803  [002] ...1 69023.970965: btrfs_release_path
<-btrfs_next_old_leaf
           mount-6803  [002] ...1 69023.970965: btrfs_search_slot
<-btrfs_next_old_leaf
           mount-6803  [002] ...1 69023.970966:
btrfs_clear_path_blocking <-btrfs_search_slot
           mount-6803  [002] ...1 69023.970966:
btrfs_set_path_blocking <-btrfs_clear_path_blocking
           mount-6803  [002] ...1 69023.970967: btrfs_bin_search
<-btrfs_search_slot
           mount-6803  [002] ...1 69023.970967: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970967: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970968: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970968: btrfs_node_key
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970969: btrfs_buffer_uptodate
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970969:
btrfs_clear_path_blocking <-btrfs_search_slot
           mount-6803  [002] ...1 69023.970970:
btrfs_set_path_blocking <-btrfs_clear_path_blocking
           mount-6803  [002] ...1 69023.970970: btrfs_bin_search
<-btrfs_search_slot
           mount-6803  [002] ...1 69023.970970: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970971: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970971: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970972: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970972: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970973: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970973: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970973: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970974: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970974: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970975: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970975: btrfs_node_key
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970976: btrfs_buffer_uptodate
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970976:
btrfs_clear_path_blocking <-btrfs_search_slot
           mount-6803  [002] ...1 69023.970976:
btrfs_set_path_blocking <-btrfs_clear_path_blocking
           mount-6803  [002] ...1 69023.970977: btrfs_bin_search
<-btrfs_search_slot
           mount-6803  [002] ...1 69023.970977: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970978: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970978: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970978: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970979: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970979: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970980: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970980: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970980: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970981: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970981: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970982: btrfs_node_key
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970982: btrfs_buffer_uptodate
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970983:
btrfs_clear_path_blocking <-btrfs_search_slot
           mount-6803  [002] ...1 69023.970983:
btrfs_set_path_blocking <-btrfs_clear_path_blocking
           mount-6803  [002] ...1 69023.970984: btrfs_bin_search
<-btrfs_search_slot
           mount-6803  [002] ...1 69023.970984: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970984: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970985: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970985: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970986: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970986: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970986: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.970987: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970987: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970988: btrfs_node_key
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970989: btrfs_buffer_uptodate
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.970989:
btrfs_set_path_blocking <-btrfs_next_old_leaf
           mount-6803  [002] ...1 69023.970990: btrfs_get_token_32
<-resolve_indirect_refs
           mount-6803  [002] ...1 69023.970990: btrfs_get_token_64
<-resolve_indirect_refs
           mount-6803  [002] ...1 69023.970991: btrfs_get_token_32
<-resolve_indirect_refs
... get_token32/64/32 continues a hundred lines or so
           mount-6803  [002] ...1 69023.971146: btrfs_get_token_32
<-resolve_indirect_refs
           mount-6803  [002] ...1 69023.971146: btrfs_get_token_64
<-resolve_indirect_refs
           mount-6803  [002] ...1 69023.971146: btrfs_next_old_leaf
<-resolve_indirect_refs
           mount-6803  [002] ...1 69023.971147: btrfs_release_path
<-btrfs_next_old_leaf
           mount-6803  [002] ...1 69023.971147: btrfs_search_slot
<-btrfs_next_old_leaf
           mount-6803  [002] ...1 69023.971148:
btrfs_clear_path_blocking <-btrfs_search_slot
           mount-6803  [002] ...1 69023.971148:
btrfs_set_path_blocking <-btrfs_clear_path_blocking
           mount-6803  [002] ...1 69023.971148: btrfs_bin_search
<-btrfs_search_slot
           mount-6803  [002] ...1 69023.971149: btrfs_comp_cpu_keys
<-generic_bin_search.constprop.14
           mount-6803  [002] ...1 69023.971149: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.971150: btrfs_get_token_64
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.971150: btrfs_node_key
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.971151: btrfs_buffer_uptodate
<-read_block_for_search.isra.12
           mount-6803  [002] ...1 69023.971151:
btrfs_clear_path_blocking <-btrfs_search_slot
           mount-6803  [002] ...1 69023.971151:
btrfs_set_path_blocking <-btrfs_clear_path_blocking
           mount-6803  [002] ...1 69023.971152: btrfs_bin_search
<-btrfs_search_slot

Repeats indefinitely.  btrace shows basically zero activity on the
array while it spins, with the occasional burst when mount &
btrfs-transaction swap off.

To recap the chain of events leading up to this:
11TB Array got completely full and started fragmenting badly.
Ran bedup and it found 600gb of duplicate files that it offline-shared.
Reboot for unrelated reasons
Enabled quota on all subvolumes to try to track where the new data is
coming from
Tried to balance metadata due to transaction CPU spikes
Force-rebooted after the array was completely lagged out.

Now attempting to mount it RW.  Readonly works, but RW has taken well
over 24 hours at this point.
