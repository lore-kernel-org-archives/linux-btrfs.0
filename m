From: Grzegorz Kabala <gk@lublin.info>
Subject: mysql (with InnoDB) on btrfs doensn't run
Date: Wed, 06 Oct 2010 15:04:23 +0200
Message-ID: <8bffff1f914a0793773dce3d5d4b94b6@taurus.advatec.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello

Actually I have problem with run mysql (InnoDB db backend) on btrfs fil=
e
system.
MySql daemon doesn=E2=80=99t run and log file contains:

101006 13:36:39 mysqld started
InnoDB: Error: tried to read 16384 bytes at offset 0 0.
InnoDB: Was only able to read -1.
101006 13:36:40 InnoDB: Operating system error number 22 in a file
operation.
InnoDB: Error number 22 means =E2=80=98Invalid argument=E2=80=99.
InnoDB: Some operating system error numbers are described at
InnoDB:
http://dev.mysql.com/doc/refman/5.0/en/operating-system-error-codes.htm=
l
InnoDB: File operation call: =E2=80=98read=E2=80=99.
InnoDB: Cannot continue operation.
101006 13:36:40 mysqld ended

101006 13:45:16 mysqld started
101006 13:45:17 InnoDB: Started; log sequence number 0 3084915
101006 13:45:17 [Note] /opt/zimbra/mysql/libexec/mysqld: ready for
connections.
Version: =E2=80=985.0.90-log=E2=80=99 socket: =E2=80=98/opt/zimbra/db/m=
ysql.sock=E2=80=99 port:
7306 Source distribution
101006 13:48:35 [Note] /opt/zimbra/mysql/libexec/mysqld: Normal shutdow=
n

101006 13:48:35 InnoDB: Starting shutdown=E2=80=A6
101006 13:48:36 InnoDB: Shutdown completed; log sequence number 0 30849=
25
101006 13:48:36 [Note] /opt/zimbra/mysql/libexec/mysqld: Shutdown compl=
ete

101006 13:48:36 mysqld ended

Used software:
CentOS 5.5 x86_64 with 2.6.32-100.0.19.el5 (from Oracle)
Btrfs tools from git tree (downloaded and compiling 10/06/2010)
MySQL v5.0.90 (from Zimbra Collaboration Suite Community)

Regards

Grzesiek

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
