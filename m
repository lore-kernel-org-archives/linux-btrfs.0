Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab3BJWTF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Feb 2013 17:19:05 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id F2D4DA4386
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2013 23:19:02 +0100 (CET)
Date: Sun, 10 Feb 2013 23:19:02 +0100
From: Arvin Schnell <aschnell@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Diff using send-receive code / RFC
Message-ID: <20130210221902.GA7270@suse.de>
References: <CAFhuFEcT=2rNA0dkyKjeEExOX5dMJt04hkgEr1QGgq8M74UYsg@mail.gmail.com> <CAFhuFEff9KV1QFE8geEw__jRAcjnBEbTkG9p6S6v0xMsf7G=Vg@mail.gmail.com> <CAFhuFEeZqu_t0geQSi-8sfGnwvxaJYqvVx9izvpb4UdGS8Zt-g@mail.gmail.com> <CAFhuFEeKTSZEr-Hy_1wj0GwKTP29SgG1sQr4Et7icBeRqh8CMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
In-Reply-To: <CAFhuFEeKTSZEr-Hy_1wj0GwKTP29SgG1sQr4Et7icBeRqh8CMQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Feb 10, 2013 at 10:21:31PM +0530, nafisa mandliwala wrote:
> Hello,
>         We're a team of 4 final year computer science students and are
> working on generating a diff between file system snapshots using the
> send receive code.

This was just implemented in snapper. Unfortunately I was in a
hurry so the code doesn't look so good. Instead of improving the
code in snapper (C++) I thought about implementing it in C so
that it can be included in btrfsprogs (and libbtrfs).

Here is an example:

# btrfs send -a -p /testsuite/.snapshots/1/snapshot /testsuite/.snapshots/2/snapshot | cat
At subvol /testsuite/.snapshots/2/snapshot
Comparing testsuite/.snapshots/1/snapshot and testsuite/.snapshots/2/snapshot.
+.... /foo
+.... /foo/bar
+.... /foo/bar/world

Attached you can find my current state. It's completely
unfinished and only works from some test-cases. To get it
compiled you either need some patches posted here earlier
(e.g. NO_FILE_DATA) or must make minor modifications.

But I would like to get feedback about this feature on the list.

Kind Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany

--ZGiS0Q5IWpPtfppv
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="send-analyser.c"

/*
 * Copyright (c) 2013 Arvin Schnell <aschnell@suse.de>
 *
 * All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc., 59
 * Temple Place - Suite 330, Boston, MA 021110-1307, USA.
 */


#define _GNU_SOURCE

#include <fcntl.h>
#include <sys/stat.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

#include "btrfs/send.h"
#include "btrfs/send-stream.h"
#include "btrfs/rbtree.h"
#include "btrfs/send-analyser.h"


struct tree_root {
	struct rb_root rb_root;
};


struct tree_node {
	struct rb_node rb_node;
	char *name;
	unsigned int status;
	struct tree_root children;
};


static void tree_root_init(struct tree_root *root)
{
	root->rb_root = RB_ROOT;
}


static struct tree_node *tree_node_init(const char *name)
{
	struct tree_node *node = malloc(sizeof(struct tree_node));
	node->name = strdup(name);
	node->status = 0;
	tree_root_init(&node->children);
	return node;
}


static struct tree_node *tree_find(struct tree_root *root, const char *name)
{
	struct rb_node *rb_node = root->rb_root.rb_node;

	while (rb_node)
	{
		struct tree_node *data = rb_entry(rb_node, struct tree_node, rb_node);

		int result = strcmp(name, data->name);
		if (result < 0)
			rb_node = rb_node->rb_left;
		else if (result > 0)
			rb_node = rb_node->rb_right;
		else
			return data;
	}

	return NULL;
}


static int tree_insert(struct tree_root *root, struct tree_node *node)
{
	struct rb_node **new = &(root->rb_root.rb_node);
	struct rb_node *parent = NULL;

	while (*new)
	{
		struct tree_node *this = rb_entry(*new, struct tree_node, rb_node);
		parent = *new;

		int result = strcmp(node->name, this->name);
		if (result < 0)
			new = &(*new)->rb_left;
		else if (result > 0)
			new = &(*new)->rb_right;
		else
			return 0;
	}

	rb_link_node(&node->rb_node, parent, new);
	rb_insert_color(&node->rb_node, &root->rb_root);

	return 1;
}


/* find node or create new one, return 1 if already existing */
static int tree_find_or_insert(struct tree_root *root, const char *name,
			       struct tree_node **node)
{
	struct rb_node **new = &(root->rb_root.rb_node);
	struct rb_node *parent = NULL;

	while (*new)
	{
		struct tree_node *this = rb_entry(*new, struct tree_node, rb_node);
		parent = *new;

		int result = strcmp(name, this->name);
		if (result < 0)
			new = &(*new)->rb_left;
		else if (result > 0)
			new = &(*new)->rb_right;
		else
		{
			*node = this;
			return 1;
		}
	}

	*node = tree_node_init(name);

	rb_link_node(&(*node)->rb_node, parent, new);
	rb_insert_color(&(*node)->rb_node, &root->rb_root);

	return 0;
}


static void tree_remove(struct tree_root *root, struct tree_node *node)
{
	rb_erase(&node->rb_node, &root->rb_root);
	free(node->name);
	free(node);
}


static void tree_cut(struct tree_root *root, struct tree_node *node)
{
	rb_erase(&node->rb_node, &root->rb_root);
}


static struct tree_node *tree_node_first(struct tree_root *root)
{
	struct rb_node *rb_node = rb_first(&root->rb_root);
	if (!rb_node)
		return NULL;
	return rb_entry(rb_node, struct tree_node, rb_node);
}


static struct tree_node *tree_node_next(struct tree_node *node)
{
	struct rb_node *rb_node = rb_next(&node->rb_node);
	if (!rb_node)
		return NULL;
	return rb_entry(rb_node, struct tree_node, rb_node);
}


static struct tree_node *full_tree_find(struct tree_root *tree,
					const char *name)
{
	const char *p = index(name, '/');
	if (!p)
	{
		return tree_find(tree, name);
	}
	else
	{
		char *t1 = strndup(name, p - name);
		struct tree_node *node = tree_find(tree, t1);
		free(t1);

		if (!node)
			return NULL;

		const char *t2 = name + (p - name + 1);
		return full_tree_find(&node->children, t2);
	}
}


static int full_tree_find_or_insert(struct tree_root *tree, const char *name,
				    struct tree_node **node)
{
	const char *p = index(name, '/');
	if (!p)
	{
		return tree_find_or_insert(tree, name, node);
	}
	else
	{
		char *t1 = strndup(name, p - name);
		struct tree_node *xnode = NULL;
		tree_find_or_insert(tree, t1, &xnode);
		free(t1);

		const char *t2 = name + (p - name + 1);
		return full_tree_find_or_insert(&xnode->children, t2, node);
	}
}


static void full_tree_remove(struct tree_root *root, const char *name)
{
	const char *p = index(name, '/');
	if (!p)
	{
		struct tree_node *node = tree_find(root, name);
		if (!node)
			return;

		tree_remove(root, node);
	}
	else
	{
		char *t1 = strndup(name, p - name);
		struct tree_node *node = tree_find(root, t1);
		free(t1);
		if (!node)
			return;

		const char *t2 = name + (p - name + 1);
		full_tree_remove(&node->children, t2);

		if (node->status == 0 && RB_EMPTY_ROOT(&node->children.rb_root))
			tree_remove(root, node);
	}
}


static void iterate(struct tree_root *root, const char *path,
		    void (*fp)(struct tree_node *node, const char *path,
			       void *user),
		    void *user)
{
	struct tree_node *node;
	for (node = tree_node_first(root); node; node = tree_node_next(node))
	{
		(*fp)(node, path, user);

		char *buf = malloc(strlen(path) + 1 + strlen(node->name) + 1);

		char *t = buf;
		t = stpcpy(t, path);
		t = stpcpy(t, "/");
		t = stpcpy(t, node->name);

		iterate(&node->children, buf, fp, user);

		free(buf);
	}
}


int analyser_create(struct btrfs_stream_analyser *analyser)
{
	analyser->files = malloc(sizeof(struct tree_root));

	tree_root_init(analyser->files);

	return 1;
}


void analyser_destroy(struct btrfs_stream_analyser *analyser)
{
	free(analyser->files);
}


static void output(struct tree_node *node, const char *path, void *user)
{
	char *s = analyser_status_to_string(node->status);
	printf("%s  %s/%s\n", s, path, node->name);
	free(s);
}


static void analyser_created(struct btrfs_stream_analyser *analyser,
			     const char *name)
{
	struct tree_node *node = NULL;
	if (full_tree_find_or_insert(analyser->files, name, &node) == 0)
	{
		node->status = BSA_CREATED;
	}
	else
	{
		node->status &= ~(BSA_CREATED | BSA_DELETED);
		node->status |= BSA_CONTENT | BSA_PERMISSIONS | BSA_USER | BSA_GROUP | BSA_XATTR;
	}
}


static void analyser_deleted(struct btrfs_stream_analyser *analyser,
			     const char *name)
{
	struct tree_node *node = full_tree_find(analyser->files, name);
	if (!node)
	{
		full_tree_find_or_insert(analyser->files, name, &node);
		node->status = BSA_DELETED;
	}
	else
	{
		full_tree_remove(analyser->files, name);
	}
}


static void analyser_read(struct btrfs_stream_analyser *analyser, int fd,
			  struct tree_node *from_node,
			  struct tree_node *to_node)
{
	DIR *dp = fdopendir(fd);
	if (dp == NULL)
	{
		close(fd);
		return;
	}

	size_t len = offsetof(struct dirent, d_name) + fpathconf(fd, _PC_NAME_MAX) + 1;
	struct dirent *ep = (struct dirent*) malloc(len);
	struct dirent *epp;

	while (readdir_r(dp, ep, &epp) == 0 && epp != NULL)
	{
		if (strcmp(ep->d_name, ".") != 0 && strcmp(ep->d_name, "..") != 0)
		{
			struct tree_node *node1 = tree_node_init(ep->d_name);
			node1->status = BSA_DELETED;
			tree_insert(&from_node->children, node1);

			struct tree_node *node2 = tree_node_init(ep->d_name);
			node2->status = BSA_CREATED;
			tree_insert(&to_node->children, node2);

			if (ep->d_type == DT_DIR)
			{
				int new_fd = openat(fd, ep->d_name, O_RDONLY | O_NOFOLLOW | O_NOATIME | O_CLOEXEC);
				analyser_read(analyser, new_fd, node1, node2);
			}
		}
	}

	free(ep);

	closedir(dp);
}


static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
			  void *user)
{
	return 0;
}


static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
			    const u8 *parent_uuid, u64 parent_ctransid,
			    void *user)
{
	return 0;
}


static int process_mkfile(const char *path, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	analyser_created(analyser, path);

	return 0;
}


static int process_mkdir(const char *path, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	analyser_created(analyser, path);

	return 0;
}


static int process_mknod(const char *path, u64 mode, u64 dev, void *user)
{
	return 0;
}


static int process_mkfifo(const char *path, void *user)
{
	return 0;
}


static int process_mksock(const char *path, void *user)
{
	return 0;
}


static int process_symlink(const char *path, const char *lnk, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	analyser_created(analyser, path);

	return 0;
}


/* like dirname */
static char *part1(const char *path)
{
	char *p = rindex(path, '/');
	if (!p)
		return strdup(".");
	else
		return strndup(path, p - path == 0 ? 1 : p - path);
}


/* like basename */
static char *part2(const char *path)
{
	char *p = rindex(path, '/');
	if (!p)
		return strdup(path);
	else
		return strdup(p + 1);
}


static int process_rename(const char *from, const char *to, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *from_node = full_tree_find(analyser->files, from);
	struct tree_node *to_node = full_tree_find(analyser->files, to);

	if (!from_node)
	{
		analyser_deleted(analyser, from);
		analyser_created(analyser, to);

		// printf("load dir %s %s\n", from, to);

		// iterate2(&analyser->files, "load 1 ", &output, NULL);
		// printf("\n");

		struct stat buf;
		if (fstatat(analyser->fd1, from, &buf, AT_SYMLINK_NOFOLLOW) == 0 && S_ISDIR(buf.st_mode))
		{
			struct tree_node *from_node = full_tree_find(analyser->files, from);
			struct tree_node *to_node = full_tree_find(analyser->files, to);

			int fd = openat(analyser->fd1, from, O_RDONLY | O_NOFOLLOW | O_NOATIME | O_CLOEXEC);
			analyser_read(analyser, fd, from_node, to_node);
			close(fd);
		}

		// iterate2(&analyser->files, "load 2 ", &output, NULL);
		// printf("\n");
	}
	else
	{
		if (!to_node)
		{
			// printf("rename %s %s\n", from, to);

			char *to_part1 = part1(to);
			char *to_part2 = part2(to);

			// iterate2(&analyser->files, "rename 1 ", &output, NULL);
			// printf("\n");

			struct tree_node *cut = full_tree_find(analyser->files, from);
			tree_cut(analyser->files, cut);

			cut->name = strdup(to_part2);

			if (strcmp(to_part1, ".") == 0)
			{
				tree_insert(analyser->files, cut);
			}
			else
			{
				to_node = full_tree_find(analyser->files, to_part1);
				if (!to_node)
				{
					analyser_created(analyser, strdup(to_part1));
					to_node = full_tree_find(analyser->files, to_part1);
				}

				tree_insert(&to_node->children, cut);
			}

			// iterate2(&analyser->files, "rename 2 ", &output, NULL);
			// printf("\n");

			free(to_part1);
			free(to_part2);
		}
		else
		{
			printf("TODO\n");
		}
	}

	return 0;
}


static int process_link(const char *path, const char *lnk, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	analyser_created(analyser, path);

	return 0;
}


static int process_unlink(const char *path, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	// printf("unlink %s\n", path);

	// iterate2(&analyser->files, "unlink 1 ", &output, NULL);
	// printf("\n");

	analyser_deleted(analyser, path);

	// iterate2(&analyser->files, "unlink 2 ", &output, NULL);
	// printf("\n");

	return 0;
}


static int process_rmdir(const char *path, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	// printf("rmdir %s\n", path);

	// iterate2(&analyser->files, "rmdir 1 ", &output, NULL);
	// printf("\n");

	analyser_deleted(analyser, path);

	// iterate2(&analyser->files, "rmdir 2 ", &output, NULL);
	// printf("\n");

	return 0;
}


static int process_write(const char *path, const void *data, u64 offset, u64 len,
			 void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_CONTENT;

	return 0;
}


static int process_clone(const char *path, u64 offset, u64 len,
			 const u8 *clone_uuid, u64 clone_ctransid,
			 const char *clone_path, u64 clone_offset, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_CONTENT;

	return 0;
}


static int process_set_xattr(const char *path, const char *name, const void *data,
			     int len, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_XATTR;

	return 0;
}


static int process_remove_xattr(const char *path, const char *name, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_XATTR;

	return 0;
}


static int process_truncate(const char *path, u64 size, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_CONTENT;

	return 0;
}


static int process_chmod(const char *path, u64 mode, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_PERMISSIONS;

	return 0;
}


static int process_chown(const char *path, u64 uid, u64 gid, void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_USER | BSA_GROUP;

	return 0;
}


static int process_utimes(const char *path, struct timespec *at,
			  struct timespec *mt, struct timespec *ct, void *user)
{
	return 0;
}


static int process_update_extent(const char *path, u64 offset, u64 len,
				 void *user)
{
	struct btrfs_stream_analyser *analyser = (struct btrfs_stream_analyser*) user;

	struct tree_node *node = NULL;
	full_tree_find_or_insert(analyser->files, path, &node);
	node->status |= BSA_CONTENT;

	return 0;
}


static struct btrfs_send_ops send_ops = {
	.subvol = process_subvol,
	.snapshot = process_snapshot,
	.mkfile = process_mkfile,
	.mkdir = process_mkdir,
	.mknod = process_mknod,
	.mkfifo = process_mkfifo,
	.mksock = process_mksock,
	.symlink = process_symlink,
	.rename = process_rename,
	.link = process_link,
	.unlink = process_unlink,
	.rmdir = process_rmdir,
	.write = process_write,
	.clone = process_clone,
	.set_xattr = process_set_xattr,
	.remove_xattr = process_remove_xattr,
	.truncate = process_truncate,
	.chmod = process_chmod,
	.chown = process_chown,
	.utimes = process_utimes,
	.update_extent = process_update_extent,
};


static void check(struct tree_node *node, const char *path, void *user)
{
	unsigned int status = node->status;

	if (status & BSA_CREATED)
		status = BSA_CREATED;
	else if (status & BSA_DELETED)
		status = BSA_DELETED;

	node->status = status;
}


int analyser_process(struct btrfs_stream_analyser *analyser, int fd)
{
	int r = btrfs_read_and_process_send_stream(fd, &send_ops, analyser);

	iterate(analyser->files, "", &check, NULL);

	return r;
}


struct haha {
	analyser_result_cb_t cb;
	void *user;
};


static void analyser_result_helper(struct tree_node *node, const char *path, void *user)
{
	struct haha *haha = (struct haha *) user;

	char *buf = malloc(strlen(path) + 1 + strlen(node->name) + 1);

	char *t = buf;
	t = stpcpy(t, path);
	t = stpcpy(t, "/");
	t = stpcpy(t, node->name);

	(haha->cb)(buf, node->status, haha->user);

	free(buf);
}


void analyser_result(struct btrfs_stream_analyser *analyser,
		     analyser_result_cb_t cb, void *user)
{
	struct haha haha = {
		.cb = cb,
		.user = user
	};

	iterate(analyser->files, "", &analyser_result_helper, &haha);
}


char *analyser_status_to_string(unsigned int status)
{
	char *str = strdup(".....");

	if (status & BSA_CREATED)
		str[0] = '+';
	else if (status & BSA_DELETED)
		str[0] = '-';
	else if (status & BSA_TYPE)
		str[0] = 't';
	else if (status & BSA_CONTENT)
		str[0] = 'c';

	if (status & BSA_PERMISSIONS)
		str[1] = 'p';

	if (status & BSA_USER)
		str[2] = 'u';

	if (status & BSA_GROUP)
		str[3] = 'g';

	if (status & BSA_XATTR)
		str[4] = 'x';		// ???

	return str;
}

--ZGiS0Q5IWpPtfppv
Content-Type: text/x-chdr; charset=us-ascii
Content-Disposition: attachment; filename="send-analyser.h"

/*
 * Copyright (c) 2013 Arvin Schnell <aschnell@suse.de>
 *
 * All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc., 59
 * Temple Place - Suite 330, Boston, MA 021110-1307, USA.
 */


#ifndef BTRFS_ANALYSER_H
#define BTRFS_ANALYSER_H


#ifdef __cplusplus
extern "C" {
#endif


#define	BSA_CREATED	(1UL << 0)
#define BSA_DELETED	(1UL << 1)
#define BSA_TYPE	(1UL << 2)
#define BSA_CONTENT	(1UL << 3)
#define BSA_PERMISSIONS (1UL << 4)
#define BSA_USER	(1UL << 5)
#define	BSA_GROUP	(1UL << 6)
#define	BSA_XATTR	(1UL << 7)


struct btrfs_stream_analyser {
	int fd1;
	int fd2;
	struct tree_root *files;
};


int analyser_create(struct btrfs_stream_analyser *analyser);

void analyser_destroy(struct btrfs_stream_analyser *analyser);

int analyser_process(struct btrfs_stream_analyser *analyser, int fd);

typedef void (*analyser_result_cb_t)(const char *path, unsigned int status,
				     void *user);

void analyser_result(struct btrfs_stream_analyser *analyser,
		     analyser_result_cb_t cb, void *user);

char *analyser_status_to_string(unsigned int status);


#ifdef __cplusplus
}
#endif


#endif

--ZGiS0Q5IWpPtfppv
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="cmds-send.c.diff"

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..340a4d2 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -39,6 +39,7 @@
 
 #include "send.h"
 #include "send-utils.h"
+#include "send-analyser.h"
 
 static int g_verbose = 0;
 
@@ -52,6 +53,9 @@ struct btrfs_send {
 
 	char *root_path;
 	struct subvol_uuid_search sus;
+
+	int do_analyse;
+	struct btrfs_stream_analyser analyser;
 };
 
 int find_mount_root(const char *path, char **mount_root)
@@ -209,21 +213,34 @@ static void *dump_thread(void *arg_)
 	char buf[4096];
 	int readed;
 
-	while (1) {
-		readed = read(s->send_fd, buf, sizeof(buf));
-		if (readed < 0) {
-			ret = -errno;
-			fprintf(stderr, "ERROR: failed to read stream from "
+	if (!s->do_analyse)
+	{
+		while (1) {
+			readed = read(s->send_fd, buf, sizeof(buf));
+			if (readed < 0) {
+				ret = -errno;
+				fprintf(stderr, "ERROR: failed to read stream from "
 					"kernel. %s\n", strerror(-ret));
-			goto out;
+				goto out;
+			}
+			if (!readed) {
+				ret = 0;
+				goto out;
+			}
+			ret = write_buf(s->dump_fd, buf, readed);
+			if (ret < 0)
+				goto out;
 		}
-		if (!readed) {
-			ret = 0;
-			goto out;
+	}
+	else
+	{
+		while (1) {
+			ret = analyser_process(&s->analyser, s->send_fd);
+			if (ret == 0)
+				goto out;
+			if (ret < 0)
+				goto out;
 		}
-		ret = write_buf(s->dump_fd, buf, readed);
-		if (ret < 0)
-			goto out;
 	}
 
 out:
@@ -234,6 +251,31 @@ out:
 	return ERR_PTR(ret);
 }
 
+
+static void setup(struct btrfs_send *s, u64 root_id1, u64 root_id2)
+{
+	struct subvol_info *si1 = subvol_uuid_search(&s->sus, root_id1, NULL, 0,
+						     NULL, subvol_search_by_root_id);
+	assert(si1);
+	s->analyser.fd1 = open(si1->path, O_RDONLY | O_NOATIME);
+
+	struct subvol_info *si2 = subvol_uuid_search(&s->sus, root_id2, NULL, 0,
+						     NULL, subvol_search_by_root_id);
+	assert(si2);
+	s->analyser.fd2 = open(si2->path, O_RDONLY | O_NOATIME);
+
+	fprintf(stderr, "Comparing %s and %s.\n", si1->path, si2->path);
+}
+
+
+static void output(const char *path, unsigned int status, void *user)
+{
+	char *s = analyser_status_to_string(status);
+	printf("%s %s\n", s, path);
+	free(s);
+}
+
+
 static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 {
 	int ret;
@@ -274,6 +316,13 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 	io_send.send_fd = pipefd[1];
 	send->send_fd = pipefd[0];
 
+	if (send->do_analyse)
+	{
+		analyser_create(&send->analyser);
+		setup(send, parent_root, root_id);
+		io_send.flags = BTRFS_SEND_FLAG_NO_FILE_DATA;
+	}
+
 	if (!ret)
 		ret = pthread_create(&t_read, &t_attr, dump_thread,
 					send);
@@ -321,6 +370,11 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 
 	ret = 0;
 
+	if (send->do_analyse)
+	{
+		analyser_result(&send->analyser, output, NULL);
+	}
+
 out:
 	if (subvol_fd != -1)
 		close(subvol_fd);
@@ -427,7 +481,7 @@ int cmd_send_start(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "vf:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "vf:i:p:a")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -468,6 +522,9 @@ int cmd_send_start(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'a':
+			send.do_analyse = 1;
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -630,6 +687,7 @@ static const char * const cmd_send_usage[] = {
 	"-v               Enable verbose debug output. Each",
 	"                 occurrency of this option increases the",
 	"                 verbose level more.",
+	"-a               Analyse the stream.",
 	"-i <subvol>      Informs btrfs send that this subvolume,",
 	"                 can be taken as 'clone source'. This can",
 	"                 be used for incremental sends.",

--ZGiS0Q5IWpPtfppv--
