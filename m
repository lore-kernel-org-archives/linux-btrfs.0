Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:14410 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbKKL5c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 06:57:32 -0500
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: Regression in btrfs: properly set the termination value of
 ctx->pos in readdir
Message-ID: <56432D2A.5040506@profihost.ag>
Date: Wed, 11 Nov 2015 12:57:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the patch btrfs: properly set the termination value of ctx->pos in
readdir introduces a regression to me.

A lot of stuff runs in "endless" or long running loops.

An example strace looks like this:
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0g8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0g8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0h8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0h8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0i8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0i8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0j8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0j8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0k8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0k8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0l8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0l8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0m8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0m8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0n8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0n8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0o8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0o8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0p8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0p8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0q8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0q8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0r8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0r8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
newfstatat(AT_FDCWD, "changelog", {st_mode=S_IFREG|0644, st_size=148,
...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0s8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0s8\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...}, 56,
0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
{st_mode=S_IFREG|0644, st_size=148, ...}, AT_SYMLINK_NOFOLLOW) = 0
semop(98307, {{0, -1, SEM_UNDO}}, 1)    = 0
msgsnd(0, {1,
"\3\0\0\0\247\r\0\0\2358\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...},
56, 0) = 0
msgrcv(32769, {1,
"\3\0\0\0\247\r\0\0\2358\0\0\0\0\0\0\0\0\0\0\345<\1\0\0\0\0\0\35\0\0\0"...},
56, 0, 0) = 56
semop(98307, {{0, 1, SEM_UNDO}}, 1)     = 0
^C <unfinished ...>
Process 3495 detached
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 36.28    0.076892          10      7717           semop
 24.25    0.051399          13      3858           newfstatat
 21.48    0.045530          12      3858           msgsnd
 17.46    0.036994          10      3859           msgrcv
  0.52    0.001110          24        46           write
------ ----------- ----------- --------- --------- ----------------
100.00    0.211925                 19338           total

Stefan
